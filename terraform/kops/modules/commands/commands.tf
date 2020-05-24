data "template_file" "create_command" {
  template = file("${path.module}/templates/kops-create-command.txt")

  vars = {
    manifest    = local.manifest
    state_store = "s3://${local.state_store.bucket.name}"
    env_vars    = local.env_vars
  }
}

data "template_file" "create_ca_command" {
  template = file("${path.module}/templates/kops-create-ca-command.txt")

  vars = {
    cluster_fqdn = local.cluster_fqdn
    pki_folder   = local.pki_folder
    state_store  = "s3://${local.state_store.bucket.name}"
    env_vars     = local.env_vars
  }
}

data "template_file" "edit_command" {
  template = file("${path.module}/templates/kops-edit-command.txt")

  vars = {
    cluster_fqdn = local.cluster_fqdn
    state_store  = "s3://${local.state_store.bucket.name}"
    env_vars     = local.env_vars
  }
}

data "template_file" "sshkey_command" {
  template = file("${path.module}/templates/kops-sshkey-command.txt")

  vars = {
    cluster_fqdn = local.cluster_fqdn
    state_store  = "s3://${local.state_store.bucket.name}"
    public_key   = local.public_key
    env_vars     = local.env_vars
  }
}

data "template_file" "update_command" {
  template = file("${path.module}/templates/kops-update-command.txt")

  vars = {
    cluster_fqdn        = local.cluster_fqdn
    state_store         = "s3://${local.state_store.bucket.name}"
    lifecycle_overrides = local.lifecycle_overrides
    env_vars            = local.env_vars
  }
}

data "template_file" "rolling_update_command" {
  template = file("${path.module}/templates/kops-rolling-update-command.txt")

  vars = {
    cluster_fqdn = local.cluster_fqdn
    state_store  = "s3://${local.state_store.bucket.name}"
    env_vars     = local.env_vars
  }
}

data "template_file" "replace_command" {
  template = file("${path.module}/templates/kops-replace-command.txt")

  vars = {
    manifest    = local.manifest
    state_store = "s3://${local.state_store.bucket.name}"
    env_vars    = local.env_vars
  }
}

data "template_file" "validate_command" {
  template = file("${path.module}/templates/kops-validate-command.txt")

  vars = {
    cluster_fqdn = local.cluster_fqdn
    state_store  = "s3://${local.state_store.bucket.name}"
    env_vars     = local.env_vars
  }
}

data "template_file" "delete_command" {
  template = file("${path.module}/templates/kops-delete-command.txt")

  vars = {
    cluster_fqdn = local.cluster_fqdn
    state_store  = "s3://${local.state_store.bucket.name}"
    env_vars     = local.env_vars
  }
}

data "template_file" "export_kubecfg_command" {
  template = file("${path.module}/templates/kops-export-kubecfg-command.txt")

  vars = {
    cluster_fqdn     = local.cluster_fqdn
    state_store      = "s3://${local.state_store.bucket.name}"
    admin_kubeconfig = local.admin_kubeconfig
    env_vars         = local.env_vars
  }
}
