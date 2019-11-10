data "template_file" "ssh_worker_socket" {
  template = file("${path.module}/templates/sshd-worker.socket.tpl")

  vars = {
    ssh_port = var.service_ssh_port
  }
}

data "template_file" "ssh_worker_service" {
  template = file("${path.module}/templates/sshd-worker@.service.tpl")

  vars = {
    host_name = local.host_name
  }
}

data "template_file" "update_sshd_config" {
  template = file("${path.module}/templates/update-sshd_config.sh.tpl")

  vars = {
    host_name     = local.host_name
    host_ssh_port = var.host_ssh_port
  }
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  part {
    merge_type   = "list(append)+dict(recurse_array)+str()"
    content      = <<EOF
#cloud-config
---
write_files:
- path: "/root/Dockerfile"
  content: |
    ${indent(4, file("${path.module}/files/Dockerfile"))}
EOF
  }

  # Installs docker, builds sshd service image, install sshd entrypoint script
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/files/install-docker.sh")
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/files/build-ssh-worker-image.sh")
  }
  part {
    content_type = "text/x-shellscript"
    content      = replace(file("${path.module}/files/install-authorized-keys-command.sh"), "{{assume_role_arn}}", "${var.assume_role_arn}")
  }
  part {
    content_type = "text/x-shellscript"
    content      = replace(file("${path.module}/files/install-sshd-entrypoint.sh"), "{{assume_role_arn}}", "${var.assume_role_arn}")
  }

  # systemd units and host sshd configuration
  part {
    merge_type   = "list(append)+dict(recurse_array)+str()"
    content      = <<EOF
#cloud-config
---
write_files:
- path: "/opt/sshd-service/nsswitch.conf"
  content: |
    ${indent(4, file("${path.module}/files/nsswitch.conf"))}
- path: "/opt/sshd-service/sshd_config"
  content: |
    ${indent(4, file("${path.module}/files/sshd_config"))}
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
    content      = data.template_file.update_sshd_config.rendered
  }

  # apt packages
  part {
    merge_type   = "list(append)+dict(recurse_array)+str()"
    content      = <<EOF
#cloud-config
---
packages:
- jq
EOF
  }

  # Install aws cli
  part {
    content_type = "text/x-shellscript"
    content      = <<EOF
#!/bin/bash
snap install aws-cli --classic
EOF
  }
}
