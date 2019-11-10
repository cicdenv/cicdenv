data "template_file" "admin_users" {
  count = length(keys(var.admin_users))

  template = file("${path.module}/templates/aws-iam-authenticator_admin-user.tpl")
  vars = {
    arn      = local.admin_arns[count.index]
    username = local.admin_usernames[count.index]
  }
}

data "template_file" "admin_roles" {
  count = length(var.admin_roles)

  template = file("${path.module}/templates/aws-iam-authenticator_admin-role.tpl")
  vars = {
    arn = var.admin_roles[count.index]
  }
}

data "template_file" "authenticator_configmap" {
  template = file("${path.module}/templates/aws-iam-authenticator_configmap.yaml.tpl")
  vars = {
    cluster_id  = var.cluster_id
    admin_users = join("\n", data.template_file.admin_users.*.rendered)
    admin_roles = join("\n", data.template_file.admin_roles.*.rendered)
  }
}

resource "local_file" "authenticator_configmap" {
  content  = data.template_file.authenticator_configmap.rendered
  filename = var.authenticator_config
}

resource "aws_s3_bucket_object" "authenticator_configmap" {
  bucket  = var.state_store
  key     = "${var.cluster_id}/addons/custom.authentication.aws/k8s-110.yaml"
  content = data.template_file.authenticator_configmap.rendered
  
  server_side_encryption = "aws:kms"
  kms_key_id             = var.state_key_arn
}
