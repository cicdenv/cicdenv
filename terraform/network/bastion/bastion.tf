module "bastion" {
  source = "../modules/bastion-service"

  region = var.region
  bucket = var.bucket

  vpc_id          = local.vpc_id
  zone_id         = local.zone_id
  public_subnets  = values(local.subnets["public"]).*.id
  private_subnets = values(local.subnets["private"]).*.id

  ami_id = local.ami_id
  
  ssh_key = "~/.ssh/kops_rsa.pub"

  assume_role = local.assume_role

  security_group = local.security_groups.bastion

  ssh_service_port = var.ssh_service_port
  ssh_host_port    = var.ssh_host_port

  providers = {
    aws.main = aws.main
  }
}
