module "jenkins_dist_instance" {
  source = "../modules/service/distributed"

  region = var.region
  bucket = var.bucket
  
  name = "dist"

  server_instance_type = "m5dn.large"
  agent_instance_type  = "z1d.2xlarge"
  
  executors = 8
}
