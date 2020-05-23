data "template_file" "ssh_worker_socket" {
  template = file("${path.module}/templates/sshd-worker.socket.tpl")

  vars = {
    ssh_port = var.ssh_service_port
  }
}

data "template_file" "ssh_worker_service" {
  template = file("${path.module}/templates/sshd-worker@.service.tpl")

  vars = {
    host_name       = local.host_name
    assume_role_arn = var.assume_role.arn
  }
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  # systemd units and host sshd configuration
  part {
    merge_type   = "list(append)+dict(recurse_array)+str()"
    content      = <<EOF
#cloud-config
---
write_files:
- path: "/etc/systemd/system/sshd-worker.socket"
  content: |
    ${indent(4, "${data.template_file.ssh_worker_socket.rendered}")}
- path: "/etc/systemd/system/sshd-worker@.service"
  content: |
    ${indent(4, "${data.template_file.ssh_worker_service.rendered}")}
- path: "/etc/systemd/system/events-worker.service"
  content: |
    ${indent(4, file("${path.module}/files/events-worker.service"))}
EOF
  }

  part {
    content_type = "text/x-shellscript"
    content      = <<EOF
#!/bin/bash

set -e 

#!/bin/bash

set -eu -o pipefail

# Download the sshd-worker image
docker pull "${local.ecr_bastion_sshd_worker.repository_url}"
docker tag "${local.ecr_bastion_sshd_worker.repository_url}" sshd-worker

# Download the events-worker image
docker pull "${local.ecr_bastion_events_worker.repository_url}"
docker tag "${local.ecr_bastion_events_worker.repository_url}" events-worker

# Configure host sshd to run on port a non-standard port
sed -i 's/^#Port 22/Port ${var.ssh_host_port}/' /etc/ssh/sshd_config
systemctl restart sshd.service
systemctl daemon-reload
systemctl enable sshd-worker.socket
systemctl start sshd-worker.socket
systemctl enable events-worker.service
systemctl start events-worker.service

# Set 'host' hostname to match dns
hostnamectl set-hostname ${local.host_name}
EOF
  }
}
