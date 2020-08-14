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

## MutatingWebHook
Uses the annotation on the kubernetes service account (sa)
to set environment variables and "file project" an AWS token
for the AWS  SDK to use.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: irsa-test
  namespace: default
spec:
  serviceAccountName: irsa-test
  containers:
  - name: irsa-test
    image: amazon/aws-cli:latest
### Everything below is added by the webhook ###
    env:
    - name: AWS_DEFAULT_REGION
      value: us-west-2
    - name: AWS_REGION
      value: us-west-2
    - name: AWS_ROLE_ARN
      value: "<iam-role-arn>"
    - name: AWS_WEB_IDENTITY_TOKEN_FILE
      value: "/var/run/secrets/irsa.amazonaws.com/serviceaccount/token"
    volumeMounts:
    - mountPath: "/var/run/secrets/irsa.amazonaws.com/serviceaccount/"
      name: aws-token
  volumes:
  - name: aws-token
    projected:
      sources:
      - serviceAccountToken:
          audience: "sts.amazonaws.com"
          expirationSeconds: 86400
          path: token
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
