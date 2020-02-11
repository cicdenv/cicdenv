data "template_file" "ssh_worker_socket" {
  template = file("${path.module}/templates/sshd-worker.socket.tpl")

  vars = {
    ssh_port = var.service_ssh_port
  }
}

data "template_file" "ssh_worker_service" {
  template = file("${path.module}/templates/sshd-worker@.service.tpl")

  vars = {
    host_name       = local.host_name
    assume_role_arn = var.assume_role_arn
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
EOF
  }

  part {
    content_type = "text/x-shellscript"
    content      = <<EOF
#!/bin/bash

set -e 

#!/bin/bash

set -eu -o pipefail

# Configure host sshd to run on port a non-standard port
sed -i 's/^#Port 22/Port ${var.host_ssh_port}/' /etc/ssh/sshd_config
systemctl restart sshd.service
systemctl enable sshd-worker.socket
systemctl start sshd-worker.socket
systemctl daemon-reload

# Set 'host' hostname to match dns
hostnamectl set-hostname ${local.host_name}

# Download the sshd-worker image
docker pull "${local.ecr_bastion_sshd_worker_url}"
docker tag "${local.ecr_bastion_sshd_worker_url}" sshd-worker
EOF
  }
}
