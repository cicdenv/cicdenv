## Purpose
Common resources for all NGINX Plus clusters in the same region/account.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> nginx/shared:${WORKSPACE}
...
```

## Importing
```hcl
data "terraform_remote_state" "nginx_shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/nginx_shared/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
iam = {
  "server" = {
    "instance_profile" = {
      "arn" = "arn:aws:iam::<account-id>:instance-profile/nginx-cluster-node"
      "name" = "nginx-cluster-node"
      "path" = "/"
      "role" = "nginx-cluster-node"
    }
  }
}
secrets = {
  "nginx_tls" = {
    "arn" = "arn:aws:secretsmanager:<region>:<main-acct-id>:secret:nginx-tls-<[a-z0-9]*6>"
    "name" = "nginx-tls"
  }
}
security_groups = {
  "server" = {
    "id" = "sg-<0x*17>"
  }
}
ssh_key_pair = {
  "key_name" = "nginx-cluster-node"
}
```
