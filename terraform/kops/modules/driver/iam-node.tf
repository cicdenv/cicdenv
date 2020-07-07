resource "aws_iam_role" "kops_node" {
  name               = "kops-node-${local.cluster_name}"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

data "aws_iam_policy_document" "kops_node" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchGetImage",
    ]

    resources = [
      "*",
    ]
  }
  
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:GetEncryptionConfiguration",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${local.state_store.bucket.name}",
    ]
  }

  statement {
    actions = [
      "s3:Get*",
    ]

    resources = [
      "arn:aws:s3:::${local.state_store.bucket.name}/${local.cluster_fqdn}/addons/*",
      "arn:aws:s3:::${local.state_store.bucket.name}/${local.cluster_fqdn}/cluster.spec",
      "arn:aws:s3:::${local.state_store.bucket.name}/${local.cluster_fqdn}/config",
      "arn:aws:s3:::${local.state_store.bucket.name}/${local.cluster_fqdn}/instancegroup/*",
      "arn:aws:s3:::${local.state_store.bucket.name}/${local.cluster_fqdn}/pki/issued/*",
      "arn:aws:s3:::${local.state_store.bucket.name}/${local.cluster_fqdn}/pki/private/kube-proxy/*",
      "arn:aws:s3:::${local.state_store.bucket.name}/${local.cluster_fqdn}/pki/private/kubelet/*",
      "arn:aws:s3:::${local.state_store.bucket.name}/${local.cluster_fqdn}/pki/ssh/*",
      "arn:aws:s3:::${local.state_store.bucket.name}/${local.cluster_fqdn}/secrets/dockerconfig",
    ]
  }

  statement {
    actions = [
      "kms:*",
    ]

    resources = [
      local.state_store.key.arn,
    ]
  }
}

resource "aws_iam_policy" "kops_node" {
  name   = "Kops-Node-${local.cluster_name}"
  policy = data.aws_iam_policy_document.kops_node.json
}

resource "aws_iam_role_policy_attachment" "kops_node" {
  role       = aws_iam_role.kops_node.name
  policy_arn = aws_iam_policy.kops_node.arn
}

resource "aws_iam_role_policy_attachment" "kops_node_apt_repo" {
  role       = aws_iam_role.kops_node.name
  policy_arn = local.apt_repo_policy.arn
}

resource "aws_iam_instance_profile" "kops_node" {
  name = "kops-node-${local.cluster_name}"
  role = aws_iam_role.kops_node.name
}
