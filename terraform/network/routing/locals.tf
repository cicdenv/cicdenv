locals {
  vpc_id = data.terraform_remote_state.shared.outputs.vpc.id
  
  availability_zones = data.terraform_remote_state.shared.outputs.availability_zones
  
  subnets      = data.terraform_remote_state.shared.outputs.subnets
  route_tables = data.terraform_remote_state.shared.outputs.route_tables
}
