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

## Testing Workflow
Build and push image changes:
```
cicdenv$ (cd terraform/shared/ecr-images/bastion-sshd-worker; make build)
📦 $USER:~/cicdenv$ (cd terraform/shared/ecr-images/bastion-sshd-worker; make push)
```

Bastion host - get update image:
```
docker pull "<main-acct-id>.dkr.ecr.<region>.amazonaws.com/bastion-sshd-worker" \
&& docker tag "<main-acct-id>.dkr.ecr.<region>.amazonaws.com/bastion-sshd-worker" "sshd-worker"
```

Test sshd-worker scripts:
```
docker run --rm -it sshd-worker bash

# edit /opt/bin/sshd-entrypoint.sh - remove sshd launch
container> vim /opt/bin/sshd-entrypoint.sh

# login
container>  IAM_ROLE=arn:aws:iam::<main-acct-id>:role/identity-resolver /opt/bin/sshd-entrypoint.sh

# Test authorized keys script
container> /opt/bin/authorized-keys-command.sh <iam-user>
```
