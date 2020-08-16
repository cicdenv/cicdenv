output "security_groups" {
  value = {
    master = {
      id = aws_security_group.kops_masters.id
    }
    node = {
      id = aws_security_group.kops_nodes.id
    }
    internal_apiserver = {
      id = aws_security_group.kops_internal_apiserver.id
    }
    external_apiserver = {
      id = aws_security_group.kops_external_apiserver.id
    }
  }
}

output "etcd_kms_key" {
  value = {
    name   = aws_kms_alias.kops_etcd.name
    key_id = aws_kms_key.kops_etcd.key_id
    arn    = aws_kms_key.kops_etcd.arn
  }
}

output "secrets" {
  value = {
    service_accounts = {
      name = aws_secretsmanager_secret.oidc_jwks.name
      arn  = aws_secretsmanager_secret.oidc_jwks.arn
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
