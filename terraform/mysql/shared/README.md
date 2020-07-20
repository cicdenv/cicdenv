## Purpose
Common resources for all MySQL as a Service instances in the same region/account.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> mysql/shared:${WORKSPACE}
...
```

## Importing
```hcl
data "terraform_remote_state" "mysql_shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/mysql_shared/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
security_groups = {
  "server" = {
    "id" = "sg-<0x*17>"
  }
}
```
