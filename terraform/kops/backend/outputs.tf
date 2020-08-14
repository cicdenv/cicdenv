output "builds" {
  value = {
    bucket = {
      id   = aws_s3_bucket.kops_builds.id
      name = aws_s3_bucket.kops_builds.bucket
      arn  = aws_s3_bucket.kops_builds.arn
    }
  }
}

output "state_store" {
  value = {
    bucket = {
      id   = aws_s3_bucket.kops_state.id
      name = aws_s3_bucket.kops_state.bucket
      arn  = aws_s3_bucket.kops_state.arn
    }
    key = {
      key_id = aws_kms_key.kops_state.key_id
      alias  = aws_kms_alias.kops_state.name
      arn    = aws_kms_key.kops_state.arn
    }
  }
}

output "secrets" {
  value = {
    service_accounts = {
      name = aws_secretsmanager_secret.kops_service_accounts.name
      arn  = aws_secretsmanager_secret.kops_service_accounts.arn
    }
    key = {
      key_id = aws_kms_key.kops_secrets.key_id
      alias  = aws_kms_alias.kops_secrets.name
      arn    = aws_kms_key.kops_secrets.arn
    }
  }
}

# IAM Roles for (Kubernetes) Service Accounts (IRSA)
output "irsa" {
  value = {
    oidc = {
      iam = {
        oidc_provider = {
          arn = aws_iam_openid_connect_provider.irsa.arn
          url = aws_iam_openid_connect_provider.irsa.url
          
          client_id_list  = aws_iam_openid_connect_provider.irsa.client_id_list 
          thumbprint_list = aws_iam_openid_connect_provider.irsa.thumbprint_list
        }
      }
      s3 = {
        oidc_issuer = {
          # Domain name of the S3 bucket (*.s3.amazonaws.com)
          bucket_name        = aws_s3_bucket.oidc.id
          bucket_domain_name = aws_s3_bucket.oidc.bucket_domain_name
        }
      }
      tls = data.tls_certificate.oidc
    }
    cluster_spec = {
      fileAssets = <<-EOF
- name: service-account-public-key-file
  path: /srv/kubernetes/assets/service-account-key
  roles: [Master]
  content: ${replace(filebase64("${path.module}/irsa/irsa-pkcs8.pub"), "/=+/", "")}
  isBase64: true
EOF
      kubeAPIServer = <<-EOF
apiAudiences:
- sts.amazonaws.com
serviceAccountIssuer: https://${aws_s3_bucket.oidc.bucket_domain_name}
serviceAccountKeyFile:
- /srv/kubernetes/server.key
- /srv/kubernetes/assets/service-account-key
serviceAccountSigningKeyFile: /srv/kubernetes/assets/service-account-signing-key
EOF
    }
  }
}
