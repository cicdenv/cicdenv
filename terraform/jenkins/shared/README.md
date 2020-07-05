## Purpose
Jenkins resources that live in sub-accounts account.

* s3 buckets
  * build cache
  * build records
* iam roles
  * servers / agents
  * colocated server+agent single instance (colo)
* security groups
  * servers / agents
  * colocated server+agent single instance (colo)

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> jenkins/common:${WORKSPACE}
...
```

## Importing
```hcl
data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/jenkins_shared/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
acm_certificate = {
  "arn" = "arn:aws:acm:<region>:<acct-id>:certificate/<guid>"
}
iam = {
  "agent" = {
    "instance_profile" = {
      "arn" = "arn:aws:iam::<acct-id>:instance-profile/jenkins-agent"
      "name" = "jenkins-agent"
      "path" = "/"
      "role" = "jenkins-agent"
    }
  }
  "colocated" = {
    "instance_profile" = {
      "arn" = "arn:aws:iam::<acct-id>:instance-profile/jenkins-colo"
      "name" = "jenkins-colo"
      "path" = "/"
      "role" = "jenkins-colo"
    }
  }
  "server" = {
    "instance_profile" = {
      "arn" = "arn:aws:iam::<acct-id>:instance-profile/jenkins-server"
      "name" = "jenkins-server"
      "path" = "/"
      "role" = "jenkins-server"
    }
  }
}
jenkins_builds_s3_bucket = {
  "arn" = "arn:aws:s3:::jenkins-builds-dev-<domain->"
  "id" = "jenkins-builds-dev-<domain->"
}
persistent_config_efs = {
  "arn" = "arn:aws:elasticfilesystem:<region>:<acct-id>:file-system/fs-<0x*8>"
  "dns_name" = "fs-<0x*8>.efs.<region>.amazonaws.com"
  "id" = "fs-<0x*8>"
}
security_groups = {
  "agent" = {
  "id" = "sg-<0x*17>"
  }
  "external_alb" = {
  "id" = "sg-<0x*17>"
  }
  "internal_alb" = {
  "id" = "sg-<0x*17>"
  }
  "server" = {
  "id" = "sg-<0x*17>"
  }
}
```
