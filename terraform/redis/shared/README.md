## Purpose
Dedicated Redis Cluster common resources.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> redis/shared:${WORKSPACE}
...
```

## Importing
```hcl
data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/redis_shared/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
iam = {
  "redis_node" = {
    "instance_profile" = {
      "arn" = "arn:aws:iam::<account-id>:instance-profile/redis-cluster-node"
      "name" = "redis-cluster-node"
      "path" = "/"
      "role" = "redis-cluster-node"
    }
  }
}
key_pairs = {
  "redis_node" = {
    "fingerprint" = "<xx>.*16"
    "key_name" = "redis-cluster-node"
    "key_pair_id" = "key-<0x*17>"
  }
}
security_groups = {
  "redis_node" = {
    "id" = "sg-<0x*17>"
  }
}
```
