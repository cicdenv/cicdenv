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
- path: "/usr/local/bin/nginx-reload.sh"
  content: |
    ${indent(4,  file("${path.module}/files/usr/local/bin/nginx-reload.sh"))}
- path: "/usr/local/bin/nginx-disks.sh"
  content: |
    ${indent(4,  file("${path.module}/files/usr/local/bin/nginx-disks.sh"))}
- path: "/etc/systemd/system/nginx-disks.service"
  content: |
    ${indent(4, file("${path.module}/files/etc/systemd/system/nginx-disks.service"))}
- path: "/etc/systemd/system/nginx.env"
  content: |
    ${indent(4, "${data.template_file.nginx_environment.rendered}")}
- path: "/etc/systemd/system/nginx.service"
  content: |
    ${indent(4, "${data.template_file.nginx_service.rendered}")}
- path: "/etc/sysctl.d/90-nginx.conf"
  content: |
    ${indent(4, file("${path.module}/files/etc/sysctl.d/90-nginx.conf"))}
- path: "/etc/nginx/certs/wildcard.cert"
  content: |
    ${indent(4, local.cert_bundle)}
- path: "/etc/nginx/nginx.conf"
  content: |
    ${indent(4, file("${path.module}/files/etc/nginx/nginx.conf"))}
- path: "/etc/nginx/conf.d/default.conf"
  content: |
    ${indent(4, file("${path.module}/files/etc/nginx/conf.d/default.conf"))}
- path: "/usr/share/nginx/html/index.html"
  content: |
    ${indent(4, file("${path.module}/files/usr/share/nginx/html/index.html"))}
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

groupadd --gid 8105 nginx
useradd  --gid 8105                  \
         --no-log-init               \
         --comment "nginx user,,,"   \
         --no-create-home            \
         --home-dir /nonexistent     \
         --shell /bin/false          \
         --uid 8105                  \
         nginx

aws secretsmanager get-secret-value         \
    --secret-id "${local.tls_secrets.arn}"  \
    --version-stage 'AWSCURRENT'            \
    --query  'SecretString'                 \
| jq -r 'fromjson | .["private-key"]'       \
| base64 -di                                \
> "/etc/nginx/certs/wildcard.key"
chmod 0600 "/etc/nginx/certs/wildcard.key"

chown -R nginx:nginx "/etc/nginx"
chown -R nginx:nginx "/usr/share/nginx"

# Set 'host' hostname to match dns
hostnamectl set-hostname ${local.host_name}

#
# kernel settings
#
service procps force-reload

chmod +x /usr/local/bin/nginx-*.sh

#
# Start nginx server
#
systemctl daemon-reload
systemctl enable nginx
systemctl start nginx
EOF
  }
}
