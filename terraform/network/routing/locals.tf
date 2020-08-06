locals {
  transit_gateway = data.terraform_remote_state.network_backend.outputs.transit_gateways["internet"]

  vpc = data.terraform_remote_state.network_backend.outputs.vpc
  
  region = data.aws_region.current.name
  
  availability_zones = values(data.terraform_remote_state.network_backend.outputs.availability_zones[local.region])
  
  subnets      = data.terraform_remote_state.network_backend.outputs.subnets
  route_tables = data.terraform_remote_state.network_backend.outputs.route_tables
}
