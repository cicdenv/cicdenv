module "bastion" {
  source = "../../networking/modules/bastion-service"

  region = var.region
  bucket = var.bucket

  zone_id         = local.zone_id
  vpc_id          = local.vpc_id
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

  ami = local.ami
  
  ssh_key = "~/.ssh/kops_rsa.pub"

  assume_role_arn = local.assume_role_arn

  security_group = local.security_group

  providers = {
    aws.main = aws.main
  }
}
