data template_file master_policy {
  template = file("${path.module}/templates/iam/master-cluster-policy.json")

  vars = {
    cluster_name  = local.cluster_name
    state_store   = local.state_store
    state_key_arn = local.state_key_arn
    etcd_key_arn  = local.etcd_key_arn
  }
}

resource aws_iam_policy master_policy {
  name = "Kops-${local.cluster_short_name}-Master"
  policy = data.template_file.master_policy.rendered
}

resource aws_iam_role_policy_attachment master_policy {
  role       = local.masters_iam_role_name
  policy_arn = aws_iam_policy.master_policy.arn
}

data template_file node_policy {
  template = file("${path.module}/templates/iam/node-cluster-policy.json")

  vars = {
    cluster_name  = local.cluster_name
    state_store   = local.state_store
    state_key_arn = local.state_key_arn
  }
}

resource aws_iam_policy node_policy {
  name = "Kops-${local.cluster_short_name}-Node"
  policy = data.template_file.node_policy.rendered
}

resource aws_iam_role_policy_attachment node_policy {
  role       = local.nodes_iam_role_name
  policy_arn = aws_iam_policy.node_policy.arn
}
