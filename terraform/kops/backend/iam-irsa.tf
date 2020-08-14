data "tls_certificate" "oidc" {
  url = "https://${aws_s3_bucket.oidc.bucket_domain_name}"
}

resource "aws_iam_openid_connect_provider" "irsa" {
  url = "https://${aws_s3_bucket.oidc.bucket_domain_name}"
  
  client_id_list = [
    "sts.amazonaws.com",
  ]
  
  thumbprint_list = [
    #trimspace(data.external.oidc_ca_sha1.result["sha1"]),
    #"a9d53002e97e00e043244f3d170d6f4c414104fd",
    data.tls_certificate.oidc.certificates.0.sha1_fingerprint,
  ]
}
