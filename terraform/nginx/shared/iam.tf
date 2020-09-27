resource "aws_iam_role" "nginx_node" {
  name = "nginx-cluster-node"
  
  assume_role_policy = data.aws_iam_policy_document.nginx_node_trust.json

  force_detach_policies = true
}

data "aws_iam_policy_document" "nginx_node_trust" {
  statement {
    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_policy" "nginx_node" {
  name   = "NGinxNode"
  policy = data.aws_iam_policy_document.nginx_node.json
}

data "aws_iam_policy_document" "nginx_node" {
  # ecr login
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = [
      "*",
    ]
  }
  
  # ecr - nginx plus image
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
    ]

    resources = [
      local.nginx_image.arn,
    ]
  }

  # secrets manager - server TLS key
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      aws_secretsmanager_secret.nginx_tls.arn,
    ]
  }
}

resource "aws_iam_role_policy_attachment" "nginx_node_apt_repo" {
  role       = aws_iam_role.nginx_node.name
  policy_arn = local.apt_repo_policy.arn
}

resource "aws_iam_role_policy_attachment" "nginx_node" {
  role       = aws_iam_role.nginx_node.name
  policy_arn = aws_iam_policy.nginx_node.arn
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.nginx_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "nginx_node" {
  name = "nginx-cluster-node"
  role = aws_iam_role.nginx_node.name
}
