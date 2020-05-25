module "server_cloudinit" {
  source = "../../user-data/server"

  terraform_state = {
    region = var.terraform_state.region
    bucket = var.terraform_state.bucket
  }
  
  jenkins_instance = var.name
}

module "agent_cloudinit" {
  source = "../../user-data/agent"

  terraform_state = {
    region = var.terraform_state.region
    bucket = var.terraform_state.bucket
  }

  jenkins_instance = var.name
  executors        = var.executors
}

module "server" {
  source = "../../compute/server"

  terraform_state = {
    region = var.terraform_state.region
    bucket = var.terraform_state.bucket
  }

  ami_id = var.ami_id

  jenkins_instance = var.name
  instance_type    = var.server_instance_type
  ami_id           = var.ami_id

  user_data = module.server_cloudinit.user_data

  instance_profile_arn = local.instance_profile.arn
}

module "agents" {
  source = "../../compute/agents"

  terraform_state = {
    region = var.terraform_state.region
    bucket = var.terraform_state.bucket
  }
  
  ami_id = var.ami_id
  
  jenkins_instance = var.name
  instance_type    = var.agent_instance_type
  ami_id           = var.ami_id

  user_data = module.agent_cloudinit.user_data
}
