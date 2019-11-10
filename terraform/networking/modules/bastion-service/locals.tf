locals {
  host_name = "bastion-${terraform.workspace}"

  cidr_blocks = var.whitelisted_service_cidr_blocks
}
