resource "aws_lambda_layer_version" "this" {
  layer_name   = local.layer_name
  description  = "Cloudflare's PKI and TLS toolkit"
  license_info = "MIT"

  s3_bucket = local.lambda_bucket.id
  s3_key    = local.layer_key

  # https://github.com/terraform-providers/terraform-provider-aws/issues/7385
  # source_code_hash = base64sha256(data.aws_s3_bucket_object.layer.etag)
  s3_object_version = data.aws_s3_bucket_object.layer.version_id

  compatible_runtimes = ["python3.8"]
}
