locals {
  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone
  private_hosted_zone = data.terraform_remote_state.network.outputs.private_dns_zone

  account_key_file = "${path.module}/../../../backend/acme/mysql-key"
}
