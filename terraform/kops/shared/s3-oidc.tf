resource "aws_s3_bucket" "oidc" {
  bucket = local.irsa_oidc_s3_bucket
  acl    = "private"

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

resource "aws_s3_bucket_object" "oidc_discovery" {
  bucket       = aws_s3_bucket.oidc.id
  key          = "/.well-known/openid-configuration"
  acl          = "public-read"
  content_type = "application/json"
  content      = <<EOF
{
  "issuer": "https://${aws_s3_bucket.oidc.bucket_domain_name}/",
  "jwks_uri": "https://${aws_s3_bucket.oidc.bucket_domain_name}/jwks.json",
  "authorization_endpoint": "urn:kubernetes:programmatic_authorization",
  "response_types_supported": [
    "id_token"
  ],
  "subject_types_supported": [
    "public"
  ],
  "id_token_signing_alg_values_supported": [
    "RS256"
  ],
  "claims_supported": [
    "sub",
    "iss"
  ]
}
EOF
}
