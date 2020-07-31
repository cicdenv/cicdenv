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

variable "source_pkr_hcl" {
  default = "https://github.com/vogtech/cicdenv/packer/ubuntu-20.04.pkr.hcl"
}

variable "root_fs" {
  type = string
}

variable "ephemeral_fs" {
  type = string
}

variable "source_owner" {
  default = "099720109477"  # or 014719181291 for root volume zfs
}

locals {
  source_ami = {
    ext4 = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"  # Ubuntu LTS
    zfs  = "zfs/ubuntu-20.04-amd64-*"                                 # Custom source AMI
  }
}

source "amazon-ebs" "builder" {
  region    = "us-west-2"
  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id
  
  source_ami_filter {
    filters = {
      name = local.source_ami[var.root_fs]

      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = [var.source_owner]
    most_recent = true
  }

  instance_type = "c5.large"
  
  associate_public_ip_address = true

  ssh_username  = "ubuntu"
  ssh_interface = "public_ip"
  ssh_timeout   = "2m"

  ami_name        = "base/ubuntu-20.04-amd64-${var.root_fs}-${var.ephemeral_fs}-{{ isotime | clean_resource_name }}"
  ami_description = "template=${var.source_pkr_hcl} source-ami=${var.root_fs} ephemeral-fs=${var.ephemeral_fs}"
  snapshot_users  = var.account_ids
  ami_users       = var.account_ids

  ami_block_device_mappings {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 50
    
    delete_on_termination = true
  }

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 50

    delete_on_termination = true
  }

  iam_instance_profile = "packer-build"

  tags = {
    Name = "base/ubuntu-20.04-amd64-${var.root_fs}-${var.ephemeral_fs}"
  }
}

build {
  sources = [
    "source.amazon-ebs.builder"
  ]

  provisioner "shell" {
    script = "./scripts/proceed-when-safe.sh"
    execute_command = "sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
  }

  provisioner "ansible" {
    playbook_file = "./ansible/playbook-${var.ephemeral_fs}.yml"
    
    ansible_env_vars = [
      "ANSIBLE_SSH_ARGS='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o AddKeysToAgent=no -o IdentitiesOnly=yes'",
    ]
  }

  provisioner "shell" {
    script = "scripts/info.sh"
    execute_command = "sudo -S sh -c '{{ .Vars }} {{ .Path }} > /tmp/info.txt'"
  }

  provisioner "file" {
    source      = "/tmp/info.txt"
    destination = "ami-info/ubuntu-20.04-${var.root_fs}-${var.ephemeral_fs}-{{ isotime \"2006-01-02T15-04-05Z07\" }}.txt"
    direction   = "download"
  }
}
