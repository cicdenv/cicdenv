locals {
  private_hosted_zone = data.terraform_remote_state.network.outputs.private_dns_zone

  vpc_id = data.terraform_remote_state.network.outputs.vpc.id
  
  availability_zones = data.terraform_remote_state.network.outputs.availability_zones
  
  subnets = data.terraform_remote_state.network.outputs.subnets

  instance_profile = data.terraform_remote_state.shared.outputs.iam.redis_node.instance_profile

  security_groups = [data.terraform_remote_state.shared.outputs.security_groups.redis_node]
}
