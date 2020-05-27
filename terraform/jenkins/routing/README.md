## Purpose
...

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> jenkins/routing:${WORKSPACE}
...
```

## Importing
```hcl
data "terraform_remote_state" "routing" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/jenkins_routing/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
dns = {
  "external" = "jenkins.<workspace>.<domain>"
  "internal" = "jenkins.<workspace>.<domain>"
}
external_alb = {
  "arn" = "arn:aws:elasticloadbalancing:<region>:<acct-id>:loadbalancer/app/jenkins-external/d54f45e2133868c2"
  "dns_name" = "jenkins-external-<N*10>.<region>.elb.amazonaws.com"
  "https_listener_arn" = "arn:aws:elasticloadbalancing:<region>:<acct-id>:listener/app/jenkins-external/<0x*16>/<0x*16>"
  "zone_id" = "<elb.amazonaws.com-zone-id>"
}
internal_alb = {
  "arn" = "arn:aws:elasticloadbalancing:<region>:<acct-id>:loadbalancer/app/jenkins-internal/d672ea6bc812b9b9"
  "dns_name" = "internal-jenkins-internal-<N*10>.<region>.elb.amazonaws.com"
  "https_listener_arn" = "arn:aws:elasticloadbalancing:<region>:<acct-id>:listener/app/jenkins-internal/<0x*16>/<0x*16>"
  "zone_id" = "<elb.amazonaws.com-zone-id>"
}
```
