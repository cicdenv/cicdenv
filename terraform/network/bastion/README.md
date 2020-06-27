## Purpose
Jump host(s) for KOPS VPCs.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy|output> network/bastion:${WORKSPACE}
...
```

## Importing
N/A.

## Outputs
```hcl
ami = {
  "id" = "ami-<0x*17>"
}

autoscaling_group = {
  "arn" = "arn:aws:autoscaling:<region>:<account-id>:autoScalingGroup:<guid>:autoScalingGroupName/bastion-service"
  "id" = "bastion-service"
  "name" = "bastion-service"
}
```
