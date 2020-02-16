## Secrets
* ssh key
  ```bash
  ssh-keygen -t rsa -b 4096 -C "jenkins@cicdenv.com" -f ~/.ssh/jenkins_rsa
  Generating public/private rsa key pair.
  Enter passphrase (empty for no passphrase): 
  Enter same passphrase again: 
  Your identification has been saved in /home/$USER/.ssh/jenkins_rsa.
  Your public key has been saved in /home/$USER/.ssh/jenkins_rsa.pub.
  The key fingerprint is:
  ... jenkins@cicdenv.com
  The key's randomart image is:
  ...
  # NOTE: no passphrase

  # Input into AWS SecretsManager management console UI
  cat ~/.ssh/jenkins_rsa     | base64 # => secretsmanager:main/jenkins-env[id_rsa]
  cat ~/.ssh/jenkins_rsa.pub | base64 # => secretsmanager:main/jenkins-env[id_rsa.pub]

  # Test from cli
  aws --profile=admin-main --region=us-west-2 \
      secretsmanager get-secret-value --secret-id "jenkins-env" \
  | jq -r '.SecretString' \
  | jq -r '.id_rsa' \
  | base64 -d
  aws --profile=admin-main --region=us-west-2 \
      secretsmanager get-secret-value --secret-id "jenkins-env" \
  | jq -r '.SecretString' \
  | jq -r '.["id_rsa"]' \
  | base64 -d
  ```
* files
  ```
  ${JENKINS_HOME}/secret.key
  ${JENKINS_HOME}/secret.key.not-so-secret
  ${JENKINS_HOME}/identity.key.enc
  ${JENKINS_HOME}/secrets/master.key
  ${JENKINS_HOME}/secrets/org.jenkinsci.main.modules.instance_identity.InstanceIdentity.KEY
  ${JENKINS_HOME}/secrets/hudson.util.Secret
  ${JENKINS_HOME}/secrets/jenkins.model.Jenkins.crumbSalt
  ```

## Jenkins service unix user
```bash
#!/bin/bash
set -eu -o pipefail

#
# unix group/user (jenkins/jenkins)
#
GROUP_ID=8008
USER_ID=8008
groupadd --gid "$GROUP_ID" jenkins
useradd  --uid "$USER_ID"               \
         --gid "$GROUP_ID"              \
         --groups "docker"              \
         --create-home                  \
         --home-dir "/var/lib/jenkins"  \
         jenkins

#
# ~/.ssh key
#
mkdir -p "/var/lib/jenkins/.ssh"
chmod 0700 "/var/lib/jenkins/.ssh"

cat <<EOFF > "/var/lib/jenkins/.ssh/config"
Host *
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
EOFF
chmod 0600 "/var/lib/jenkins/.ssh/config"

aws secretsmanager get-secret-value --secret-id "jenkins-env" \
| jq -r '.SecretString' \
| jq -r '.id_rsa' \
| base64 -d \
> "/var/lib/jenkins/.ssh/id_rsa"
chmod 0600 "/var/lib/jenkins/.ssh/id_rsa"

aws secretsmanager get-secret-value --secret-id "jenkins-env" \
| jq -r '.SecretString' \
| jq -r '.["id_rsa.pub"]' \
| base64 -d \
> "/var/lib/jenkins/.ssh/id_rsa.pub"
chmod 0600 "/var/lib/jenkins/.ssh/id_rsa.pub"

chown -R jenkins:jenkins "/var/lib/jenkins/.ssh"

#
# ~/.docker/config.son - ECR auto login
#
mkdir -p "/var/lib/jenkins/.docker"
chmod 0700 "/var/lib/jenkins/.docker"

cat <<EOFF > "/var/lib/jenkins/.docker/config.json"
{
  "credsStore": "ecr-login"
}
EOFF
chmod 0600 "/var/lib/jenkins/.docker/config.json"

chown -R jenkins:jenkins "/var/lib/jenkins/.docker"
```

## Kernel Settings
`/etc/sysctl.d/NN-*.conf` =&gt; `service procps start` to make effective
* http://manpages.ubuntu.com/manpages/bionic/man8/sysctl.8.html
* https://superuser.com/questions/625840/how-do-i-reload-sysctl-from-sysctl-d-directory

`sysctl` values to handle large numbers of containers: (setting, tuned, default)
```
fs.aio-max-nr                                       1048576              # 65536
vm.swappiness                                       1                    # 60
net.ipv4.ip_local_port_range                        1024 65000           # 32768 60999 
net.ipv4.tcp_tw_reuse                               1                    # 0 
net.ipv4.tcp_fin_timeout                            15                   # 60
net.core.somaxconn                                  4096                 # 128
net.core.netdev_max_backlog                         4096                 # 1000
net.core.rmem_max                                   16777216             # 212992
net.core.wmem_max                                   16777216             # 212992
net.ipv4.tcp_max_syn_backlog                        20480                # 512    
net.ipv4.tcp_max_tw_buckets                         400000               # 65536  
net.ipv4.tcp_no_metrics_save                        1                    # 0
net.ipv4.tcp_rmem                                   4096 87380 16777216  # 4096 87380 6291456
net.ipv4.tcp_syn_retries                            2                    # 6
net.ipv4.tcp_synack_retries                         2                    # 5
net.ipv4.tcp_wmem                                   4096 65536 16777216  # 4096 16384 4194304
net.netfilter.nf_conntrack_tcp_timeout_established  86400                # 432000
net.ipv4.neigh.default.gc_thresh1                   8096                 # 128
net.ipv4.neigh.default.gc_thresh2                   12288                # 512 
net.ipv4.neigh.default.gc_thresh3                   16384                # 1024
``` 

## Bridge Network host netns access
This allows the jenkins containers to run on a non-default bridge network but still talk
to host services bound to host network namespace loopback interface (localhost).

For example: host level vault, consol, envoy processes ...

```
NOTE: requires a proxy that listens on the bridge network loopback interface
      and forwards traffic to the host netns loopback interface with iptables
      dnat rules
```

Values:
```
aws_ecr_url: {{ aws_account_id }}.dkr.ecr.{{ ansible_ec2_placement_region }}.amazonaws.com
host_proxy_version: 1.0

docker_network_name:    build
docker_network_cidr:    172.19.0.0/16
docker_network_gateway: 172.19.0.1

host_netns_localhost_services: [8500, 8200]
```

host-netns-proxy.service (jinja template syntax)
```
[Unit]
Description=Bridge Network to Host NetNS Proxy
Requires=docker.service
After=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=/usr/bin/docker pull {{ aws_ecr_url }}/host-netns-proxy:{{ host_proxy_version }}
ExecStartPre=/usr/bin/docker tag {{ aws_ecr_url }}/host-netns-proxy:{{ host_proxy_version }} host-netns-proxy:{{ host_proxy_version }}
ExecStart=/usr/bin/docker run --rm              \
    --name host-netns-proxy                     \
    --network '{{ docker_network_name }}'       \
    --net-alias host.docker.internal            \
    --net-alias consul                          \
    --net-alias vault                           \
    --cap-add=NET_ADMIN --cap-add=NET_RAW       \
    'host-proxy:{{ host_proxy_version }}'

[Install]
WantedBy=multi-user.target
```

build-network.service (jinja template syntax)
```
[Unit]
Description=Build Network Installer
Requires=docker.service
After=docker.service
Before=build-host-proxy.service

[Service]
Type=oneshot
ExecStart=/bin/bash -c "\
if ! docker network inspect {{ docker_network_name }} &>/dev/null; then                            \
    /usr/bin/docker network create --subnet {{ docker_network_cidr }}                              \
                                   --gateway {{ docker_network_gateway }}                          \
                                   -o com.docker.network.bridge.name=br-{{ docker_network_name }}  \
                                   {{ docker_network_name }};                                      \
    sysctl -w net.ipv4.conf.br-{{ docker_network_name }}.route_localnet=1; \
    for port in {{ host_netns_localhost_services }}; do \
        iptables --table nat \
                 --insert PREROUTING \
                 --protocol tcp \
                 --in-interface br-{{ docker_network_name }} \
                 --dport $${port} \
                 --jump DNAT \
                 --to-destination 127.0.0.1:$${port}; \
    done; \
fi \
"

[Install]
WantedBy=multi-user.target
```
