terraform {
  required_version = ">= 0.13.0"
  backend "s3" {
    key = "kops_workloads_irsa-test/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
