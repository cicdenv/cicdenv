## Purpose
Mutating Webhook implementation for IAM Roles for (Kubernetes) Service Accounts (IRSA).

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> shared/ecr-images/pod-identity-webhook:main
...
```

## Image Build
```bash
cicdenv$ (cd terraform/shared/ecr-images/pod-identity-webhook/; make build)
```

## Update ECR
```bash
📦 $USER:~/cicdenv$ (cd terraform/shared/ecr-images/pod-identity-webhook/; make push)
```

## Importing
```hcl
data "terraform_remote_state" "ecr_pod_identity_webhook" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_ecr-images_pod-identity-webhook/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
ecr = {
  "pod_identity_webhook" = {
    "arn" = "arn:aws:ecr:<region>:<main-acct-id>:repository/pod-identity-webhook"
    "id" = "pod-identity-webhook"
    "name" = "pod-identity-webhook"
    "registry_id" = "<main-acct-id>"
    "repository_url" = "<main-acct-id>.dkr.ecr.<region>.amazonaws.com/pod-identity-webhook"
  }
}
```

## Links
* https://github.com/aws/amazon-eks-pod-identity-webhook
  * https://github.com/aws/amazon-eks-pod-identity-webhook/blob/master/SELF_HOSTED_SETUP.md
