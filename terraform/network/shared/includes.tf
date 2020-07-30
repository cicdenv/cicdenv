data "aws_availability_zones" "azs" {}
data "aws_caller_identity" "current" {}

data "null_data_source" "cluster_tags" {
  count = length(var.cluster_names)

  inputs = {
    Key   = "kubernetes.io/cluster/${var.cluster_names[count.index]}"
    Value = "shared"
  }
}

data "aws_s3_bucket_object" "event_subscriber_lambda" {
  bucket = local.lambda_bucket.id
  key    = local.event_subscriber_lambda_key
}

data "aws_s3_bucket_object" "ssh_keys_lambda" {
  bucket = local.lambda_bucket.id
  key    = local.ssh_keys_lambda_key
}
