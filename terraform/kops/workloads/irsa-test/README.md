## Purpose
IAM Roles for Kubernetes Service Accounts (IRSA) test resources.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> kops/workloads/irsa-test:${WORKSPACE}
...
```

## Examples
```bash
cicdenv$ cicdctl kubectl <cluster>:dev create sa "irsa-test"
cicdenv$ cicdctl kubectl <cluster>:dev annotate sa "irsa-test" \
  "irsa.amazonaws.com/role-arn=arn:aws:iam::<account-id>:role/irsa-test"

cicdenv$ cicdctl kubectl <cluster>:dev run "irsa-test" \
  -i --rm --image amazon/aws-cli \
  --serviceaccount "irsa-test" \
  -- sts get-caller-identity
{
    "UserId": "AROAQG3KU4HVRWXMPU6TT:botocore-session-1597434611",
    "Account": "<account-id>",
    "Arn": "arn:aws:sts::<account-id>:assumed-role/irsa-test/botocore-session-1597434611"
}

cicdenv$ cicdctl kubectl <cluster>:dev run "irsa-test" \
  -i --rm --image amazon/aws-cli \
  --serviceaccount "irsa-test" \
  -- s3 ls "s3://kops-builds-cicdenv-com"
PRE kops/
```

## Importing
```hcl
data "terraform_remote_state" "irsa-test" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/kops_workloads_irsa-test/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
iam = {
  "irsa_test" = {
    "role" = {
      "arn" = "arn:aws:iam::<account-id>:role/irsa-test"
      "name" = "irsa-test"
    }
  }
}
```
