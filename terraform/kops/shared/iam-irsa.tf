data "tls_certificate" "oidc" {
  url = "https://${aws_s3_bucket.oidc.bucket_domain_name}"
}

resource "aws_iam_openid_connect_provider" "irsa" {
  url = "https://${aws_s3_bucket.oidc.bucket_domain_name}"
  
  client_id_list = [
    "sts.amazonaws.com",
  ]
  
  thumbprint_list = [
    data.tls_certificate.oidc.certificates.0.sha1_fingerprint,
  ]
}
