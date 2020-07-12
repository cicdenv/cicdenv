locals {
  ami_id = var.base_ami_id != "" ? var.base_ami_id : data.terraform_remote_state.amis.outputs.base_ami.id
}
