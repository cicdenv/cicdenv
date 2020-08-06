## Purpose
Host access

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> network/bastion/backend:main
...
```

## Importing
```hcl
data "terraform_remote_state" "network_bastion_backend" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/network_bastion_backend/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
bastion_events = {
  "security_group" = {
    "id" = "sg-<0x*17>"
  }
}
bastion_service = {
  "security_group" = {
    "id" = "sg-<0x*17>"
  }
}

cloudwatch_log_groups = {
  "iam_user_event_subscriber" = {
    "arn" = "arn:aws:logs:<region>:<account-id>:log-group:/aws/lambda/event-subscriber-bastion-service:*"
    "name" = "/aws/lambda/event-subscriber-bastion-service"
  }
}
lambdas = {
  "iam_user_event_subscriber" = {
    "function_name" = "shared-ec2-keypair-generator"
    "handler" = "lambda.lambda_handler"
    "runtime" = "python3.7"
    "vpc_config" = [
      {
        "security_group_ids" = [
          "sg-<0x*17>",
        ]
        "subnet_ids" = [
          "subnet-<0x*17>",
          "subnet-<0x*17>",
          "subnet-<0x*17>",
        ]
        "vpc_id" = "vpc-<0x*17>"
      },
    ]
  }
}
```
