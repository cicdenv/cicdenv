#!/bin/bash

cat <<'EOF' > "instances/${name}/locals.tf"
locals {
  ami_ids = {
    server = var.base_ami_id != "" ? var.base_ami_id : data.terraform_remote_state.amis.outputs.base_amis["ext4-zfs"].id
    agent  = var.base_ami_id != "" ? var.base_ami_id : data.terraform_remote_state.amis.outputs.base_amis["ext4-ext4"].id
  }
}
EOF

cat <<EOF >> "instances/${name}/variables.tf"

variable "server_instance_type" {
  default = "${tf_vars[server_instance_type]}"
}
variable "agent_instance_type" {
  default = "${tf_vars[agent_instance_type]}"
}
variable "agent_count" {
  default = ${tf_vars[agent_count]}
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
  
  ami_ids = local.ami_ids
  
  name = "${name}"

  server_instance_type = var.server_instance_type
  agent_instance_type  = var.agent_instance_type
  agent_count          = var.agent_count

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

output "amis" {
  value = {
    server = local.ami_ids.server
    agent  = local.ami_ids.agent
  }
}

output "url" {
  value = "https://\${module.jenkins_instance.dns.external_name}"
}
EOF
