locals {
  network_cidr = var.ipam[terraform.workspace].shared.network_cidr

  transit_gateway = data.terraform_remote_state.network_backend.outputs.transit_gateways["internet"]

  private_hosted_zone = data.terraform_remote_state.network_backend.outputs.private_dns_zone
  
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
    "SubnetType"             = "Utility"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "SubnetType"                      = "Private"
  }

  cluster_tags = zipmap(data.null_data_source.cluster_tags.*.outputs.Key,
                        data.null_data_source.cluster_tags.*.outputs.Value)

  acct_azs = zipmap(
    data.aws_availability_zones.azs.zone_ids, 
    data.aws_availability_zones.azs.names
  )

  region = data.aws_region.current.name

  # Map this accounts AZs to the (up to 3) AZs in the main acct
  main_azs = data.terraform_remote_state.network_backend.outputs.availability_zones[local.region]

  availability_zones = [for zone_id in keys(local.main_azs) : local.acct_azs[zone_id]]

  lambda_bucket = data.terraform_remote_state.lambda.outputs.lambda.bucket

  ssh_keys_function_name = "shared-ec2-keypair-generator"
  ssh_keys_lambda_key    = "functions/${local.ssh_keys_function_name}.zip"
}
