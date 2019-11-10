data "null_data_source" "cluster_tags" {
  count = length(compact(split("\n", file("${path.module}/data/${terraform.workspace}/clusters.txt"))))

  inputs = {
    Key   = "kubernetes.io/cluster/${element(compact(split("\n", file("${path.module}/data/${terraform.workspace}/clusters.txt"))), count.index)}"
    Value = "shared"
  }
}

locals {
  network_cidr = "10.16.0.0/16"

  domain = var.domain

  cluster_names = compact(split("\n", file("${path.module}/data/${terraform.workspace}/clusters.txt")))

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

  # Limit AZs to no more than 3
  availability_zones = split(",", length(data.aws_availability_zones.azs.names) > 3 ? 
      join(",", slice(data.aws_availability_zones.azs.names, 0, 3)) 
    : join(",", data.aws_availability_zones.azs.names))
}
