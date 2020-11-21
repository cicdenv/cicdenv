data "template_file" "admin_roles" {
  for_each = toset(local.admin_roles)

  template = file("${path.module}/templates/aws-iam-authenticator/admin-role.tpl")
  vars = {
    arn = each.key
  }
}

data "template_file" "authenticator_configmap" {
  template = file("${path.module}/templates/aws-iam-authenticator/configmap.yaml.tpl")
  vars = {
    cluster_id  = local.cluster_fqdn
    admin_roles = join("\n", [for admin_role in data.template_file.admin_roles : admin_role.rendered])
  }
}

resource "local_file" "authenticator_configmap" {
  content  = data.template_file.authenticator_configmap.rendered
  filename = local.authenticator_config
}

resource "aws_s3_bucket_object" "authenticator_configmap" {
  bucket  = local.state_store.bucket.name
  key     = "${local.cluster_fqdn}/addons/custom.authentication.aws/k8s-110.yaml"
  content = data.template_file.authenticator_configmap.rendered
  
  server_side_encryption = "aws:kms"
  
  kms_key_id = local.state_store.key.arn

  acl = "bucket-owner-full-control"
}
