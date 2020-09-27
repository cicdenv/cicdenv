resource "aws_iam_role" "redis_node" {
  name = "redis-cluster-node"
  
  assume_role_policy = data.aws_iam_policy_document.redis_node_trust.json

  force_detach_policies = true
}

data "aws_iam_policy_document" "redis_node_trust" {
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

resource "aws_iam_role_policy_attachment" "redis_node_apt_repo" {
  role       = aws_iam_role.redis_node.name
  policy_arn = local.apt_repo_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.redis_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "redis_node" {
  name = "redis-cluster-node"
  role = aws_iam_role.redis_node.name
}
