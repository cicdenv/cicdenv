locals {
  transit_gateway = data.terraform_remote_state.network_backend.outputs.transit_gateways["internet"]

  backend_route_tables = data.terraform_remote_state.network_backend.outputs.route_tables

  shared_vpc = {
    vpc = data.terraform_remote_state.network_shared.outputs.vpc
  
    subnets = data.terraform_remote_state.network_shared.outputs.subnets

    route_tables = data.terraform_remote_state.network_shared.outputs.route_tables
  }
}
