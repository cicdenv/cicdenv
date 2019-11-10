module "bastion" {
  source = "../../networking/modules/bastion-service"

  zone_id         = local.zone_id
  vpc_id          = local.vpc_id
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

  ami = local.ami
  
  ssh_key = "~/.ssh/kops_rsa.pub"

  assume_role_arn = local.assume_role_arn

  security_groups = local.security_groups

  whitelisted_service_cidr_blocks = var.whitelisted_cidr_blocks
  whitelisted_host_cidr_blocks    = var.whitelisted_cidr_blocks

  providers = {
    aws.main = "aws.main"
  }
}
