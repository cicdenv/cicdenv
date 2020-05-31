data "template_cloudinit_config" "config" {
  gzip = true

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
- path: "/usr/local/bin/jenkins-server-disks.sh"
  content: |
    ${indent(4, "${data.template_file.jenkins_server_disks.rendered}")}
- path: "/etc/systemd/system/jenkins-server-disks.service"
  content: |
    ${indent(4, file("${path.module}/files/jenkins-server-disks.service"))}
- path: "/etc/systemd/system/jenkins-server.env"
  content: |
    ${indent(4, "${data.template_file.jenkins_server_environment.rendered}")}
- path: "/etc/systemd/system/jenkins-server.service"
  content: |
    ${indent(4, "${data.template_file.jenkins_server_service.rendered}")}
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
| jq -r '.SecretString'                             \
| jq -r '.["id_rsa"]'                               \
| base64 -di                                        \
> "/var/lib/jenkins/.ssh/id_rsa"
chmod 0600 "/var/lib/jenkins/.ssh/id_rsa"

aws secretsmanager get-secret-value                 \
    --secret-id "${local.jenkins_env_secrets.arn}"  \
| jq -r '.SecretString'                             \
| jq -r '.["id_rsa.pub"]'                           \
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

# Set 'host' hostname to match dns
hostnamectl set-hostname ${local.host_name}

#
# kernel settings
#
service procps reload

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
    | jq -r '.SecretString'                                \
    | jq -r ".[\"$${secret}\"]"                            \
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
    | jq -r '.SecretString'                                \
    | jq -r ".[\"$${secret}\"]"                            \
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
# Required packages
#
apt-get install nfs-common -y

chmod +x "/usr/local/bin/jenkins-server-disks.sh"

#
# Start jenkins server
#
systemctl daemon-reload
systemctl enable jenkins-server
systemctl start jenkins-server
EOF
  }
}
