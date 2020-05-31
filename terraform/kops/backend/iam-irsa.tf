#
# SHA1 thumbprint of the root CA certificate (default to *.s3.amazonaws.com)
# https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
#
data "external" "oidc_ca_sha1" {
  program = ["python", "${path.module}/bin/ca_sha1.py"]

  query = {
    uri = aws_s3_bucket.oidc.bucket_domain_name
  }
}

resource "aws_iam_openid_connect_provider" "irsa" {
  url = "https://${aws_s3_bucket.oidc.bucket_domain_name}"
  
  client_id_list = [
    "sts.amazonaws.com",
  ]
  
  thumbprint_list = [
    trimspace(data.external.oidc_ca_sha1.result["sha1"]),
  ]
}
