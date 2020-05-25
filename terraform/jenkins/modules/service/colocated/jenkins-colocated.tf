module "cloudinit" {
  source = "../../user-data/colocated"

  terraform_state = {
    region = var.terraform_state.region
    bucket = var.terraform_state.bucket
  }
  
  jenkins_instance = var.name
  executors        = var.executors
}

module "colocated" {
  source = "../../compute/server"

  terraform_state = {
    region = var.terraform_state.region
    bucket = var.terraform_state.bucket
  }
  
  jenkins_instance = var.name
  instance_type    = var.instance_type
  ami_id           = var.ami_id

  user_data = module.cloudinit.user_data

  instance_profile_arn = local.instance_profile.arn
}
