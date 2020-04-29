data "template_cloudinit_config" "config" {
  gzip = true

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
    ${indent(4, "${data.template_file.jenkins_agent_environment.rendered}")}
- path: "/etc/systemd/system/jenkins-agent.service"
  content: |
    ${indent(4, "${data.template_file.jenkins_agent_service.rendered}")}
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

export AWS_DEFAULT_REGION=$(curl -m5 -sS http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')

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

chmod +x "/usr/local/bin/jenkins-agent-disks.sh"

#
# Start jenkins agent
#
systemctl daemon-reload
systemctl enable jenkins-agent
systemctl start jenkins-agent
EOF
  }
}
