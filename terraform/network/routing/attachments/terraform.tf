terraform {
  required_version = ">= 0.13.0"
  backend "s3" {
    key = "network_routing_attachments/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
