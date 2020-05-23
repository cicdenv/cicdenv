## Purpose
Common networking resources for all compute resources.

NOTE: per hour resources (nat gateways, VPC-endpoints) reside in [network/routing](../routing).

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> network/shared:${WORKSPACE}
...
```
