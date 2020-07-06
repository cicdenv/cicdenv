## Purpose
Common host access ssh key.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> network/shared/ssh:${WORKSPACE}
...
```

## Importing
```hcl
data "terraform_remote_state" "shared_ssh" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/network_shared_ssh/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
key_pairs = {
  "shared" = {
    "fingerprint" = "<xx>.*16"
    "key_name" = "shared"
    "key_pair_id" = "key-<0x*17>"
  }
}
```
