## Purpose
Common state-store for all KOPS kubernetes clusters in all regions/accounts.

## Workspaces
N/A.  All accounts store kops state in the same bucket in main-acct/us-west-2.

## Init
Create KOPS CA.
```
cicdenv$ terraform/kops/backend/bin/ca-create.sh
...
2019/06/25 12:09:55 [INFO] signed certificate with serial number ....
```

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|output> kops/backend:main
...
```

NOTE:
```
The sub-account admin IAM role is similarly sourced to provide access to users/workspaced-terraform.
```

## Importing
```hcl
data "terraform_remote_state" "backend" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/kops_backend/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
irsa = {
  "cluster_spec" = {
    "fileAssets" = "content: ...\n  isBase64: true\n  name: service-account-signing-key-file\n  path: /srv/kubernetes/assets/service-account-signing-key\n- content: ...\n  isBase64: true\n  name: service-account-key-file\n  path: /srv/kubernetes/assets/service-account-key\n"
    "kubeAPIServer" = "apiAudiences:\n- sts.amazonaws.com\nserviceAccountIssuer: https://oidc-irsa-cicdenv-com.s3.amazonaws.com\nserviceAccountKeyFile:\n- /srv/kubernetes/server.key\n- /srv/kubernetes/assets/service-account-key\nserviceAccountSigningKeyFile: /srv/kubernetes/assets/service-account-signing-key\n"
  }
  "oidc" = {
    "iam" = {
      "oidc_provider" = {
        "arn" = "arn:aws:iam::<main-acct-id>:oidc-provider/oidc-irsa-cicdenv-com.s3.amazonaws.com"
        "client_id_list" = [
          "sts.amazonaws.com",
        ]
        "thumbprint_list" = [
          "3fe05b486e3f0987130ba1d4ea0f299539a58243",
        ]
        "url" = "oidc-irsa-cicdenv-com.s3.amazonaws.com"
      }
    }
    "s3" = {
      "oidc_issuer" = {
        "bucket_domain_name" = "oidc-irsa-cicdenv-com.s3.amazonaws.com"
        "bucket_name" = "oidc-irsa-cicdenv-com"
      }
    }
  }
}
state_store = {
  "bucket" = {
    "arn" = "arn:aws:s3:::kops.cicdenv.com"
    "id" = "kops.cicdenv.com"
    "name" = "kops.cicdenv.com"
  }
  "key" = {
    "alias" = "alias/kops-state"
    "arn" = "arn:aws:kms:<region>:<main-acct-id>:key/<guid>"
    "key_id" = "<guid>"
  }
}
```
