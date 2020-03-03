#!/bin/bash

cat <<EOF > "instances/${instance_name}/jenkins.tf"
module "jenkins_instance" {
  source = "../../modules/service/distributed"

  region = var.region
  bucket = var.bucket
  
  name = "${instance_name}"

  server_instance_type = "m5dn.large"
  agent_instance_type  = "z1d.2xlarge"
  
  executors = 8
}
EOF

cat <<EOF > "instances/${instance_name}/outputs.tf"
output "autoscaling_groups" {
  value = module.jenkins_instance.autoscaling_groups
}
EOF
