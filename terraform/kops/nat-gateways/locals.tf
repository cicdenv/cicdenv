locals {
  availability_zones   = data.terraform_remote_state.shared.outputs.availability_zones
  public_subnets       = data.terraform_remote_state.shared.outputs.public_subnet_ids
  private_route_tables = data.terraform_remote_state.shared.outputs.private_route_table_ids
}
