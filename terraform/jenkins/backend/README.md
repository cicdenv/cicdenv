## Purpose
Jenkins main acct items.

* SecretsManager secrets

NOTE: ECR images are managed by `shared/ecr-images/jenkins`.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> jenkins/backend:main
...
```

## Importing
```hcl
data "terraform_remote_state" "backend" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/jenkins_backend/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
jenkins_key = {
  "alias" = "alias/jenkins"
  "arn" = "arn:aws:kms:<region>:<main-acct-id>:key/<guid>"
  "key_id" = "<guid>"
}
secrets = {
  "agent" = {
    "arn" = "arn:aws:secretsmanager:<region>:<main-acct-id>:secret:jenkins-agent-<[a-z0-9]*6>"
    "name" = "jenkins-agent"
  }
  "env" = {
    "arn" = "arn:aws:secretsmanager:<region>:<main-acct-id>:secret:jenkins-env-<[a-z0-9]*6>"
    "name" = "jenkins-env"
  }
  "github" = {
    "ec2" = {
      "arn" = "arn:aws:secretsmanager:<region>:<main-acct-id>:secret:jenkins-github-<[a-z0-9]*6>"
      "name" = "jenkins-github"
    }
    "localhost" = {
      "arn" = "arn:aws:secretsmanager:<region>:<main-acct-id>:secret:jenkins-github-localhost-<[a-z0-9]*6>"
      "name" = "jenkins-github-localhost"
    }
  }
  "server" = {
    "arn" = "arn:aws:secretsmanager:<region>:<main-acct-id>:secret:jenkins-server-<[a-z0-9]*6>"
    "name" = "jenkins-server"
  }
}
```
