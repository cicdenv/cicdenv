#!/bin/bash

cat <<EOF >> "instances/${name}/variables.tf"

variable "server_instance_type" {
  default = "${tf_vars[server_instance_type]}"
}
variable "agent_instance_type" {
  default = "${tf_vars[agent_instance_type]}"
}
variable "executors" {
  default = ${tf_vars[executors]}
}
EOF

cat <<EOF > "instances/${name}/jenkins.tf"
module "jenkins_instance" {
  source = "../../modules/service/distributed"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }
  
  ami_id = local.ami_id
  
  name = "${name}"

  server_instance_type = var.server_instance_type
  agent_instance_type  = var.agent_instance_type
  
  executors = var.executors
}
EOF

cat <<EOF > "instances/${name}/outputs.tf"
output "type" {
  value = "${type}"
}

output "autoscaling_groups" {
  value = module.jenkins_instance.autoscaling_groups
}
EOF
