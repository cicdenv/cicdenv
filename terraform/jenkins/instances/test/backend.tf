terraform {
  required_version = ">= 0.12.21"
  backend "s3" {
    key = "jenkins-instances-test/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
