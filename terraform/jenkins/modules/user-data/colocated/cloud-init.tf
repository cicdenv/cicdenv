data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # systemd units and host sshd configuration
  part {
    merge_type   = "list(append)+dict(recurse_array)+str()"
    content      = <<EOF
#cloud-config
---
write_files:
- path: "/etc/systemd/system/jenkins-network.service"
  content: |
    ${indent(4, file("${path.module}/files/jenkins-network.service"))}
- path: "/usr/local/bin/jenkins-agent-disks.sh"
  content: |
    ${indent(4, file("${path.module}/files/jenkins-agent-disks.sh"))}
- path: "/etc/systemd/system/jenkins-agent-disks.service"
  content: |
    ${indent(4, file("${path.module}/files/jenkins-agent-disks.service"))}
- path: "/etc/systemd/system/jenkins-agent.env"
  content: |
    ${indent(4, data.template_file.jenkins_agent_environment.rendered)}
- path: "/etc/systemd/system/jenkins-agent.service"
  content: |
    ${indent(4, data.template_file.jenkins_agent_service.rendered)}
- path: "/usr/local/bin/jenkins-server-disks.sh"
  content: |
    ${indent(4, data.template_file.jenkins_server_disks.rendered)}
- path: "/etc/systemd/system/jenkins-server-disks.service"
  content: |
    ${indent(4, file("${path.module}/files/jenkins-server-disks.service"))}
- path: "/etc/systemd/system/jenkins-server.env"
  content: |
    ${indent(4, data.template_file.jenkins_server_environment.rendered)}
- path: "/etc/systemd/system/jenkins-server.service"
  content: |
    ${indent(4, data.template_file.jenkins_server_service.rendered)}
- path: "/etc/sysctl.d/90-containers.conf"
  content: |
    ${indent(4, file("${path.module}/../common/files/etc/sysctl.d/90-containers.conf"))}
EOF
  }

  part {
    content_type = "text/x-shellscript"
    content      = <<EOF
#!/bin/bash
set -eu -o pipefail

set -x

IMDSv2_TOKEN=$(curl -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 30" -sL "http://169.254.169.254/latest/api/token")
export AWS_DEFAULT_REGION=$(curl -H "X-aws-ec2-metadata-token:$IMDSv2_TOKEN" -m5 -sS http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')

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

aws secretsmanager get-secret-value                 \
    --secret-id "${local.jenkins_env_secrets.arn}"  \
    --version-stage 'AWSCURRENT'                    \
    --query  'SecretString'                         \
| jq -r 'fromjson | .["id_rsa"]'                    \
| base64 -di                                        \
> "/var/lib/jenkins/.ssh/id_rsa"
chmod 0600 "/var/lib/jenkins/.ssh/id_rsa"

aws secretsmanager get-secret-value                 \
    --secret-id "${local.jenkins_env_secrets.arn}"  \
    --version-stage 'AWSCURRENT'                    \
    --query  'SecretString'                         \
| jq -r 'fromjson | .["id_rsa.pub"]'                \
| base64 -di                                        \
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

#
# /var/lib/jenkins/.aws/config to set default region
#
mkdir -p "/var/lib/jenkins/.aws"
chmod 0700 "/var/lib/jenkins/.aws"

cat <<EOFF > "/var/lib/jenkins/.aws/config"
[default]
region = $${AWS_DEFAULT_REGION}
output = json
EOFF
chmod 0600 "/var/lib/jenkins/.aws/config"

chown -R jenkins:jenkins "/var/lib/jenkins/.aws"

# Set 'host' hostname to match dns
hostnamectl set-hostname ${local.host_name}

#
# kernel settings
#
service procps start

#
# Jenkins id, crypto files
#

# /var/jenkins_home/*
mkdir -p "/var/jenkins_home"
chmod 0700 "/var/jenkins_home"
chown -R jenkins:jenkins "/var/jenkins_home"
for secret in               \
'secret.key'                \
'secret.key.not-so-secret'  \
'identity.key.enc'          \
; do
    aws secretsmanager get-secret-value                    \
        --secret-id "${local.jenkins_server_secrets.arn}"  \
        --version-stage 'AWSCURRENT'                       \
        --query  'SecretString'                            \
    | jq -r "fromjson | .[\"$${secret}\"]"                 \
    | base64 -di                                           \
    > "/var/jenkins_home/$${secret}"
    chmod 0600 "/var/jenkins_home/$${secret}"
    chown -R jenkins:jenkins "/var/jenkins_home/$${secret}"
done

# /var/jenkins_home/secrets/*
mkdir -p "/var/jenkins_home/secrets"
chmod 0700 "/var/jenkins_home/secrets"
chown -R jenkins:jenkins "/var/jenkins_home/secrets"
for secret in                                                                \
'secrets/master.key'                                                         \
'secrets/org.jenkinsci.main.modules.instance_identity.InstanceIdentity.KEY'  \
'secrets/hudson.util.Secret'                                                 \
'secrets/jenkins.model.Jenkins.crumbSalt'                                    \
; do
    aws secretsmanager get-secret-value                    \
        --secret-id "${local.jenkins_server_secrets.arn}"  \
        --version-stage 'AWSCURRENT'                       \
        --query  'SecretString'                            \
    | jq -r "fromjson | .[\"$${secret}\"]"                 \
    | base64 -di                                           \
    > "/var/jenkins_home/$${secret}"
    chmod 0600 "/var/jenkins_home/$${secret}"
    chown -R jenkins:jenkins "/var/jenkins_home/$${secret}"
done

#
# server tls self-signed cert
#
# view with `openssl x509 -in "/var/lib/jenkins/tls/server-cert.pem" -text -noout`
mkdir -p /var/lib/jenkins/tls
chmod 0700 "/var/lib/jenkins/tls"
openssl req \
    -newkey rsa:2048 \
    -nodes \
    -keyout "/var/lib/jenkins/tls/server-key.pem" \
    -x509 \
    -days 36500 \
    -out "/var/lib/jenkins/tls/server-cert.pem" \
    -subj "/C=US/ST=CA/L=San Francisco/O=cicdenv/OU=local/CN=${local.server_url}/emailAddress=jenkins@cicdenv.com" \
    -passin "pass:jenkins"
openssl rsa \
    -in "/var/lib/jenkins/tls/server-key.pem" \
    -out "/var/lib/jenkins/tls/server-rsa.pem"
chown -R jenkins:jenkins "/var/lib/jenkins/tls"

#
# Wait for the dpkg/apt lock(s) to be available for at least 3 secs.
# 
quiet_period=3  # seconds
countdown="$quiet_period"
while [[ "$countdown" -gt 0 ]]; do
    echo "apt/dpkg lock - quiet period countdown: $${countdown} ..."
    for lock_file in                    \
        /var/lib/dpkg/lock              \
        /var/lib/dpkg/lock-frontend     \
        /var/lib/apt/lists/lock         \
        /var/cache/apt/archives/lock; do
        # echo "Checking lock: $${lock_file} ..."
        if [[ $(fuser "$lock_file") ]]; then
            echo "Waiting for lock: $${lock_file} ..."
            countdown="$quiet_period"  # Reset quiet period countdown
        fi
    done
    sleep 1
    countdown=$(($countdown - 1))
done

#
# Required packages
#
apt-get update
apt-get install nfs-common -y

chmod +x "/usr/local/bin/jenkins-server-disks.sh"
chmod +x "/usr/local/bin/jenkins-agent-disks.sh"

#
# Start jenkins server
#
systemctl daemon-reload
systemctl enable jenkins-server
systemctl start jenkins-server

#
# Start jenkins agent
#
systemctl daemon-reload
systemctl enable jenkins-agent
systemctl start jenkins-agent
EOF
  }
}
