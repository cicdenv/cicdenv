locals {
  ssh_key = "~/.ssh/id-shared-ec2-${terraform.workspace}.pub"

  shared_ec2_keypair = data.terraform_remote_state.network.outputs.secrets.shared_ec2_keypair
}
