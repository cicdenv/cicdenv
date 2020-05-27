## Purpose
Bastion service worker container image.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> shared/ecr-images/bastion-sshd-worker:main
...
```

## Image Maintenance
```bash
📦 $USER:~/cicdenv/shared/ecr-images/bastion-sshd-worker$ make
```

## Importing
```hcl
data "terraform_remote_state" "ecr_bastion_sshd_worker" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_ecr-images_bastion-sshd-worker/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
ecr = {
  "bastion_sshd_worker" = {
    "arn" = "arn:aws:ecr:<region>:<main-acct-id>:repository/bastion-sshd-worker"
    "id" = "bastion-sshd-worker"
    "name" = "bastion-sshd-worker"
    "registry_id" = "<main-acct-id>"
    "repository_url" = "<main-acct-id>.dkr.ecr.<region>.amazonaws.com/bastion-sshd-worker"
  }
}
```
