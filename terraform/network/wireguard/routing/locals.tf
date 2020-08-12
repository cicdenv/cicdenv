locals {
  public_hosted_zone = {
    name    = data.aws_route53_zone.public_main.name
    zone_id = data.aws_route53_zone.public_main.zone_id

    # .name with trailing dot stripped
    domain = replace(data.aws_route53_zone.public_main.name, "/\\.$/", "")
  }

  vpc = data.terraform_remote_state.network_backend.outputs.vpc
  
  subnets = data.terraform_remote_state.network_backend.outputs.subnets
}
