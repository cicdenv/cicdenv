locals {
  availability_zones = data.terraform_remote_state.network_shared.outputs.availability_zones
  subnets            = data.terraform_remote_state.network_shared.outputs.subnets
  vpc                = data.terraform_remote_state.network_shared.outputs.vpc
  
  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone
  private_hosted_zone = data.terraform_remote_state.domains.outputs.private_dns_zone

  instance_profile = data.terraform_remote_state.mysql_group.outputs.iam.server.instance_profile
  
  security_groups = flatten([
    values(data.terraform_remote_state.mysql_shared.outputs.security_groups),
    values(data.terraform_remote_state.mysql_group.outputs.security_groups),
  ])

  creds_secret = data.terraform_remote_state.mysql_group.outputs.secrets.mysql_group_creds
  tls_secrets  = data.terraform_remote_state.mysql_group.outputs.secrets.mysql_group_tls

  certs = data.terraform_remote_state.mysql_group_tls.outputs.acme.certificates

  host_name = "mysql-${var.name}-${var.id}-${terraform.workspace}"
  
  main_account = data.terraform_remote_state.accounts.outputs.main_account

  mysql_version = "8.0.21"

  from_email = "systemd@cicdenv.com"
  to_email   = "fred.vogt+systemd@gmail.com"

  dump_schedule = "0/4:00:00"
  snap_schedule = "*-*-* 07:00:00"

  databases = "test"
  
  mysql_backups = data.terraform_remote_state.mysql_shared.outputs.mysql_backups
}
