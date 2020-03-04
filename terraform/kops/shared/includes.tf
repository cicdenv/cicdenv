data "aws_availability_zones" "azs" {}
data "aws_caller_identity" "current" {}

data "null_data_source" "cluster_tags" {
  count = length(var.cluster_names)

  inputs = {
    Key   = "kubernetes.io/cluster/${var.cluster_names[count.index]}"
    Value = "shared"
  }
}
