variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_id" {
  type = string
}

variable "account_ids" {
  type = list(string)
}

variable "root_fs" {
  type = string
}

variable "source_pkr_hcl" {
  default = "https://github.com/vogtech/cicdenv/packer/ubuntu-20.04-ebssurrogate.pkr.hcl"
}

source "amazon-ebssurrogate" "builder" {
  region    = "us-west-2"
  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id

  source_ami_filter {
    filters = {
      name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"

      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }

  instance_type = "c5.large"
  ena_support = true
  
  associate_public_ip_address = true

  ssh_username  = "ubuntu"
  ssh_interface = "public_ip"
  ssh_timeout   = "2m"

  ami_name        = "${var.root_fs}/ubuntu-20.04-amd64-${formatdate("YYYY-MM-DD'T'HH-mm-ssZ", timestamp())}"
  ami_description = "template=${var.source_pkr_hcl}"

  snapshot_users  = var.account_ids
  ami_users       = var.account_ids

  ami_virtualization_type = "hvm"

  ami_root_device {
    source_device_name = "/dev/xvdf"

    device_name = "/dev/xvda"
    volume_size = 50

    delete_on_termination = true
  }

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 50

    delete_on_termination = true
  }

  launch_block_device_mappings {
    device_name = "/dev/xvdf"
    volume_type = "gp2"
    volume_size = 50

    delete_on_termination = true
  }

  iam_instance_profile = "packer-build"

  tags = {
    Name = "${var.root_fs}/ubuntu-20.04-amd64"
  }
}

build {
  sources = [
    "source.amazon-ebssurrogate.builder"
  ]

  provisioner "file" {
    source = "ebssurrogate/files/sources-us-west-2.list"
    destination = "/tmp/sources.list"
  }

  provisioner "file" {
    source = "ebssurrogate/${var.root_fs}/files/growpart-root.cfg"
    destination = "/tmp/growpart-root.cfg"
  }

  provisioner "file" {
    source = "ebssurrogate/${var.root_fs}/files/packages.txt"
    destination = "/tmp/packages.txt"
  }

  provisioner "file" {
    source = "ebssurrogate/${var.root_fs}/scripts/chroot-bootstrap.sh"
    destination = "/tmp/chroot-bootstrap.sh"
  }

  provisioner "shell" {
    script = "scripts/proceed-when-safe.sh"
    execute_command = "sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
  }

  provisioner "shell" {
    script = "ebssurrogate/${var.root_fs}/scripts/surrogate-bootstrap.sh"
    execute_command = "sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
  }
}
