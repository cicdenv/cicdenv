data "template_file" "admin_users" {
  for_each = var.admin_users

  template = file("${path.module}/templates/aws-iam-authenticator_admin-user.tpl")
  vars = {
    username = each.key
    arn      = each.value
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
    admin_users = join("\n", [for admin_user in data.template_file.admin_users : admin_user.rendered])
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
