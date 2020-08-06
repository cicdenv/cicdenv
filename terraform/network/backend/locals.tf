locals {
  organization = data.terraform_remote_state.accounts.outputs.organization

  azs = data.aws_availability_zones.azs
  
  region = data.aws_region.current.name

  # For each supported region we take the first 3 zones
  zone_count = length(local.azs.zone_ids) > 3 ? 3 : length(local.azs.zone_ids)

  # The mapping of {region => zone-ids} used by the main account
  availability_zones = {
    "${local.region}" = zipmap(
      slice(local.azs.zone_ids, 0, local.zone_count), 
      slice(local.azs.names,    0, local.zone_count)
    )
  }
  
  network_cidr = var.ipam["main"].backend.network_cidr
}
