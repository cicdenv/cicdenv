locals {
  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone

  account_key_file = "${path.module}/../../backend/acme/nginx-key"
}
