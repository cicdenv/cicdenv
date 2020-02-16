module "jenkins_test_instance" {
  source = "../modules/service/colocated"

  region = var.region
  bucket = var.bucket
  
  name = "test"

  instance_type = "m5dn.4xlarge"

  executors = 12
}
