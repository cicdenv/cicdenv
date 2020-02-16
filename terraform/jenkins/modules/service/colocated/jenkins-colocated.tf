module "cloudinit" {
  source = "../../user-data/colocated"

  region = var.region
  bucket = var.bucket
  
  jenkins_instance = var.name
  executors        = var.executors
}

module "colocated_instance" {
  source = "../../compute/server"

  region = var.region
  bucket = var.bucket
  
  jenkins_instance = var.name
  instance_type    = var.instance_type

  user_data = module.cloudinit.user_data

  instance_profile_arn = local.instance_profile.arn
}
