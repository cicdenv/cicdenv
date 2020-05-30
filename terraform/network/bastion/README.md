## Purpose
Jump host(s) for KOPS VPCs.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy|output> network/bastion:${WORKSPACE}
...
```

## SSH Key
`~/.ssh/manual-testing.pub`

## libnss_iam
Me and George are working on an official release.
Currently there is none.

Currently serving out of `s3://kops.cicdenv.com` because this authorizes by S3 VPC endpoint.

* Using a build from: https://github.com/vogtech/libnss-iam/tree/fred-01
* Follow the build instructions: https://github.com/gfleury/libnss-iam

Upload to s3:
```bash
libnss-iam$ AWS_OPTS="--profile=admin-main --region=us-west-2"
libnss-iam$ for item in iam libnss_iam.so.2 libnss-iam-0.1.deb; do
    aws $AWS_OPTS s3 cp --acl 'bucket-owner-full-control' "${item}" "s3://kops.cicdenv.com/libnss_iam/${item}"
    aws $AWS_OPTS s3api put-object-tagging --bucket=kops.cicdenv.com --key="libnss_iam/${item}" \
        --tagging 'TagSet=[{Key=Source,Value=https://github.com/vogtech/libnss-iam/tree/fred-01},{Key=Upstream,Value=https://github.com/gfleury/libnss-iam}]'
done
libnss-iam$ 
```

## Importing
N/A.

## Outputs
```hcl
autoscaling_group = {
  "arn" = "arn:aws:autoscaling:<region>:<account-id>:autoScalingGroup:<guid>:autoScalingGroupName/bastion-service"
  "id" = "bastion-service"
  "name" = "bastion-service"
}
cloudwatch_log_groups = {
  "iam_user_event_subscriber" = {
    "arn" = "arn:aws:logs:<region>:<account-id>:log-group:/aws/lambda/event-subscriber-bastion-service:*"
    "name" = "/aws/lambda/event-subscriber-bastion-service"
  }
}
dns = bastion.dev.cicdenv.com
iam = {
  "bastion_service" = {
    "instance_profile" = {
      "arn" = "arn:aws:iam::<account-id>:instance-profile/bastion"
    }
    "policy" = {
      "arn" = "arn:aws:iam::<account-id>:policy/BastionService"
      "name" = "BastionService"
      "path" = "/"
    }
    "role" = {
      "arn" = "arn:aws:iam::<account-id>:role/bastion"
      "name" = "bastion"
    }
  }
  "iam_user_event_subscriber" = {
    "policy" = {
      "arn" = "arn:aws:iam::<account-id>:policy/iam-user-event-subscriber"
      "name" = "iam-user-event-subscriber"
      "path" = "/"
    }
    "role" = {
      "arn" = "arn:aws:iam::<account-id>:role/iam-user-event-subscriber"
      "name" = "iam-user-event-subscriber"
    }
  }
}
lambdas = {
  "iam_user_event_subscriber" = {
    "function_name" = "event-subscriber-bastion-service"
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
nlb = {
  "arn" = "arn:aws:elasticloadbalancing:<region>:<account-id>:loadbalancer/net/bastion-nlb/<0x*16>"
  "dns_name" = "bastion-nlb-<0x*16>.elb.<region>.amazonaws.com"
  "zone_id" = "<elb.amazonaws.com-zone-id>"
}
```
