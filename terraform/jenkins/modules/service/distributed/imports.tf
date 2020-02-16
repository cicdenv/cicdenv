data "terraform_remote_state" "jenkins_shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/jenkins-shared/terraform.tfstate"
    region = var.region
  }
}
