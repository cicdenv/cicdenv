## Purpose
Site-wide host access (bastion) loadbalancer.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> network/bastion/routing:main
...
```

## Importing
```hcl
data "terraform_remote_state" "network_bastion_routing" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/network_bastion_routing/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
dns = bastion.cicdenv.com
nlb = {
  "arn" = "arn:aws:elasticloadbalancing:<region>:<account-id>:loadbalancer/net/bastion-nlb/<0x*16>"
  "dns_name" = "bastion-nlb-<0x*16>.elb.<region>.amazonaws.com"
  "zone_id" = "<elb.amazonaws.com-zone-id>"
  "target_groups" = [
    {
      "arn" = "arn:aws:elasticloadbalancing:<region>:<account-id>:targetgroup/bastion-service/<0x*16>"
    },
    {
      "arn" = "arn:aws:elasticloadbalancing:<region>:<account-id>:targetgroup/bastion-host/<0x*16>"
    },
  ]
}
```
