terraform {
  required_version = ">= 0.12.28"
  backend "s3" {
    key = "jenkins_instances_dist/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
