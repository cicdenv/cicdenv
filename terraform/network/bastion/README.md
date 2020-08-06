## Purpose
Jump host(s) for SSH host access to EC2 instances in private subnets.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy|output> network/bastion:main
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
