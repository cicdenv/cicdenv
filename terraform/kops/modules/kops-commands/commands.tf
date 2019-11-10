data "template_file" "create_command" {
  template = file("${path.module}/templates/kops-create-command.txt")

  vars = {
    kops_manifest = var.kops_manifest
    state_store   = "s3://${var.state_store}"
    env_vars      = local.env_vars
  }
}

data "template_file" "create_ca_command" {
  template = file("${path.module}/templates/kops-create-ca-command.txt")

  vars = {
    cluster_name = var.cluster_name
    pki_folder   = var.pki_folder
    state_store  = "s3://${var.state_store}"
    env_vars     = local.env_vars
  }
}

data "template_file" "edit_command" {
  template = file("${path.module}/templates/kops-edit-command.txt")

  vars = {
    cluster_name = var.cluster_name
    state_store  = "s3://${var.state_store}"
    env_vars     = local.env_vars
  }
}

data "template_file" "sshkey_command" {
  template = file("${path.module}/templates/kops-sshkey-command.txt")

  vars = {
    cluster_name = var.cluster_name
    state_store  = "s3://${var.state_store}"
    public_key   = var.public_key
    env_vars     = local.env_vars
  }
}

data "template_file" "update_command" {
  template = file("${path.module}/templates/kops-update-command.txt")

  vars = {
    cluster_name        = var.cluster_name
    state_store         = "s3://${var.state_store}"
    lifecycle_overrides = "--lifecycle-overrides IAMRole=ExistsAndWarnIfChanges,IAMRolePolicy=ExistsAndWarnIfChanges,IAMInstanceProfileRole=ExistsAndWarnIfChanges"
    env_vars            = local.env_vars
  }
}

data "template_file" "rolling_update_command" {
  template = file("${path.module}/templates/kops-rolling-update-command.txt")

  vars = {
    cluster_name = var.cluster_name
    state_store  = "s3://${var.state_store}"
    env_vars     = local.env_vars
  }
}

data "template_file" "replace_command" {
  template = file("${path.module}/templates/kops-replace-command.txt")

  vars = {
    kops_manifest = var.kops_manifest
    state_store   = "s3://${var.state_store}"
    env_vars      = local.env_vars
  }
}

data "template_file" "validate_command" {
  template = file("${path.module}/templates/kops-validate-command.txt")

  vars = {
    cluster_name = var.cluster_name
    state_store  = "s3://${var.state_store}"
    env_vars     = local.env_vars
  }
}

data "template_file" "delete_command" {
  template = file("${path.module}/templates/kops-delete-command.txt")

  vars = {
    cluster_name = var.cluster_name
    state_store  = "s3://${var.state_store}"
    env_vars     = local.env_vars
  }
}

data "template_file" "export_kubecfg_command" {
  template = file("${path.module}/templates/kops-export-kubecfg-command.txt")

  vars = {
    cluster_name     = var.cluster_name
    state_store      = "s3://${var.state_store}"
    admin_kubeconfig = var.admin_kubeconfig
    env_vars         = local.env_vars
  }
}
