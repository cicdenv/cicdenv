## Purpose
Jenkins service server, agent container images.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> shared/ecr-images/jenkins:main
...
```

## Importing
```hcl
data "terraform_remote_state" "ecr_jenkins" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_ecr-images_jenkins/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
ecr = {
  "ci_builds" = {
    "arn" = "arn:aws:ecr:<region>:<main-acct-id>:repository/ci-builds"
    "id" = "ci-builds"
    "name" = "ci-builds"
    "registry_id" = "<main-acct-id>"
    "repository_url" = "<main-acct-id>.dkr.ecr.<region>.amazonaws.com/ci-builds"
  }
  "jenkins_agent" = {
    "arn" = "arn:aws:ecr:<region>:<main-acct-id>:repository/jenkins-agent"
    "id" = "jenkins-agent"
    "latest" = "2.NNN-yyyy-mm-dd-NN"
    "name" = "jenkins-agent"
    "registry_id" = "<main-acct-id>"
    "repository_url" = "<main-acct-id>.dkr.ecr.<region>.amazonaws.com/jenkins-agent"
  }
  "jenkins_server" = {
    "arn" = "arn:aws:ecr:<region>:<main-acct-id>:repository/jenkins-server"
    "id" = "jenkins-server"
    "latest" = "2.NNN-yyyy-mm-dd-NN"
    "name" = "jenkins-server"
    "registry_id" = "<main-acct-id>"
    "repository_url" = "<main-acct-id>.dkr.ecr.<region>.amazonaws.com/jenkins-server"
  }
}
```
