#!/bin/bash

cat <<EOF > "instances/${instance_name}/jenkins.tf"
module "jenkins_instance" {
  source = "../../modules/service/colocated"

  region = var.region
  bucket = var.bucket
  
  name = "${instance_name}"

  instance_type = "m5dn.4xlarge"

  executors = 12
}
EOF

cat <<EOF > "instances/${instance_name}/outputs.tf"
output "type" {
  value = "${instance_type}"
}

output "autoscaling_groups" {
  value = module.jenkins_instance.autoscaling_groups
}
EOF
