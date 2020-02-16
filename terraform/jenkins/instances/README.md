## Purpose
Jenkins service instances.

## Workspaces
This state is per-account.

## Samples
```hcl
module "jenkins_test_instance" {
  source = "modules/service/colocated"

  name = "test"

  instance_type = "m5dn.4xlarge"

  executors = 12
}

module "jenkins_dist_instance" {
  source = "modules/service/distributed"

  name = "dist"

  server_instance_type = "m5dn.large"
  agent_instance_type  = "z1d.2xlarge"
  
  executors = 8
}
```

## Usage
```
cicdenv$ cicdctl <init|plan|apply|destroy> jenkins/instances:${WORKSPACE}
...
```
