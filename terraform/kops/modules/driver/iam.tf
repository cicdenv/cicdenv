data template_file master_policy {
  template = file("${path.module}/templates/iam/master-cluster-policy.json")

  vars = {
    cluster_fqdn  = local.cluster_fqdn
    state_store   = local.state_store.bucket.name
    state_key_arn = local.state_store.key.arn
    etcd_key_arn  = local.etcd_kms_key.arn
  }
}

resource aws_iam_policy master_policy {
  name = "Kops-${local.cluster_name}-Master"
  policy = data.template_file.master_policy.rendered
}

resource aws_iam_role_policy_attachment master_policy {
  role       = local.iam.master.role.name
  policy_arn = aws_iam_policy.master_policy.arn
}

data template_file node_policy {
  template = file("${path.module}/templates/iam/node-cluster-policy.json")

  vars = {
    cluster_fqdn  = local.cluster_fqdn
    state_store   = local.state_store.bucket.name
    state_key_arn = local.state_store.key.arn
  }
}

resource aws_iam_policy node_policy {
  name = "Kops-${local.cluster_name}-Node"
  policy = data.template_file.node_policy.rendered
}

resource aws_iam_role_policy_attachment node_policy {
  role       = local.iam.node.role.name
  policy_arn = aws_iam_policy.node_policy.arn
}
