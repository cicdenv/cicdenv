locals {
  # kops/backend
  state_store = data.terraform_remote_state.backend.outputs.state_store

  # kops/shared
  iam = data.terraform_remote_state.shared.outputs.iam

  # iam/users
  admin_users = data.terraform_remote_state.iam_users.outputs.admins
  
  region = data.aws_region.current.name
  
  # kops-driver:
  cluster_fqdn = var.cluster_fqdn
  admin_roles  = var.admin_roles
  ca_cert      = var.input_files.ca_cert

  authenticator_config = var.output_files.authenticator_config

  # shared/ecr-images/pod-identity-webhook
  ecr_irsa_hook_image = "${data.terraform_remote_state.pod_identity_webhook.outputs.ecr_repo.repository_url}:latest"
  ecr_cert_inic_image = "${data.terraform_remote_state.certificate_init_container.outputs.ecr_repo.repository_url}:latest"
  ecr_kapprover_image = "${data.terraform_remote_state.certificate_request_approver.outputs.ecr_repo.repository_url}:latest"
}
