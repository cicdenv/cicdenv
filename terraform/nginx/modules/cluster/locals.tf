locals {
  availability_zones = data.terraform_remote_state.network_shared.outputs.availability_zones
  subnets            = data.terraform_remote_state.network_shared.outputs.subnets
  vpc                = data.terraform_remote_state.network_shared.outputs.vpc
  
  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone
  private_hosted_zone = data.terraform_remote_state.domains.outputs.private_dns_zone

  instance_profile = data.terraform_remote_state.nginx_shared.outputs.iam.server.instance_profile
  security_groups  = values(data.terraform_remote_state.nginx_shared.outputs.security_groups)
  tls_secrets      = data.terraform_remote_state.nginx_shared.outputs.secrets.nginx_tls

  cert_bundle = data.terraform_remote_state.nginx_shared_tls.outputs.acme.certificate.bundle

  nginx_plus_image = {
    latest = "r22"
  }

  host_name = "nginx-${var.name}-${terraform.workspace}"

  nginx_image  = data.terraform_remote_state.ecr_nginx.outputs.ecr_repo
  image_tag    = data.terraform_remote_state.ecr_nginx.outputs.image_tag
  
  main_account = data.terraform_remote_state.accounts.outputs.main_account
}
