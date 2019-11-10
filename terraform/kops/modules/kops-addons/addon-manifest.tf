resource "aws_s3_bucket_object" "addon_manifest" {
  bucket  = var.state_store
  key     = "${var.cluster_id}/addons/custom-channel.yaml"
  content = file("${path.module}/files/custom-channel.yaml")

  server_side_encryption = "aws:kms"
  kms_key_id             = var.state_key_arn
}
