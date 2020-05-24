resource "aws_s3_bucket_object" "addon_manifest" {
  bucket  = local.state_store.bucket.name
  key     = "${local.cluster_fqdn}/addons/custom-channel.yaml"
  content = file("${path.module}/files/custom-channel.yaml")

  server_side_encryption = "aws:kms"

  kms_key_id = local.state_store.key.arn
}
