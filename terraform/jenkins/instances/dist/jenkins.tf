module "jenkins_instance" {
  source = "../../modules/service/distributed"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }
  
  ami_id = local.ami_id
  
  name = "dist"

  server_instance_type = var.server_instance_type
  agent_instance_type  = var.agent_instance_type
  agent_count          = var.agent_count

  executors = var.executors
}
