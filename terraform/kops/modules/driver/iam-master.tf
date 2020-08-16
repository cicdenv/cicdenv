resource "aws_iam_role" "kops_master" {
  name               = "kops-master-${local.cluster_name}"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

data "aws_iam_policy_document" "kops_master" {
  statement {
    actions = [
        "ec2:CreateSecurityGroup",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DescribeInstances",
        "ec2:DescribeLaunchTemplateVersions",
        "ec2:DescribeRegions",
        "ec2:DescribeRouteTables",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVolumes",
        "ec2:DescribeVolumesModifications",
        "ec2:DescribeVpcs",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifyVolume",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "autoscaling:GetAsgForInstance",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:AttachLoadBalancerToSubnets",
      "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateLoadBalancerPolicy",
      "elasticloadbalancing:CreateLoadBalancerListeners",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:ConfigureHealthCheck",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteLoadBalancerListeners",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerPolicies",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DetachLoadBalancerFromSubnets",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
      "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "iam:ListServerCertificates",
      "iam:GetServerCertificate"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
      "route53:GetHostedZone",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/${local.private_dns_zone.zone_id}"
    ]
  }

  statement {
    actions = [
      "route53:GetChange"
    ]

    resources = [
      "arn:aws:route53:::change/*",
    ]
  }

  statement {
    actions = [
      "route53:ListHostedZones"
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
      "ec2:AttachVolume",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateRoute",
      "ec2:DeleteRoute",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteVolume",
      "ec2:DetachVolume",
      "ec2:RevokeSecurityGroupIngress",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/KubernetesCluster"
      values   = [
        local.cluster_fqdn,
      ]
    }
  }

  statement {
    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/KubernetesCluster"
      values   = [
        local.cluster_fqdn,
      ]
    }
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
      "arn:aws:s3:::${local.state_store.bucket.name}/${local.cluster_fqdn}/*",
    ]
  }

  statement {
    actions = [
      "s3:Put*",
    ]

    resources = [
      "arn:aws:s3:::${local.state_store.bucket.name}/${local.cluster_fqdn}/backups/*",
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

  statement {
    actions = [
      "kms:*",
    ]

    resources = [
      local.etcd_kms_key.arn,
    ]
  }

  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      local.secrets.service_accounts.arn,
    ]
  }
}

resource "aws_iam_policy" "kops_master" {
  name = "Kops-Master-${local.cluster_name}"

  policy = data.aws_iam_policy_document.kops_master.json
}

resource "aws_iam_role_policy_attachment" "kops_master" {
  role       = aws_iam_role.kops_master.name
  policy_arn = aws_iam_policy.kops_master.arn
}

resource "aws_iam_role_policy_attachment" "kops_master_apt_repo" {
  role       = aws_iam_role.kops_master.name
  policy_arn = local.apt_repo_policy.arn
}

resource "aws_iam_instance_profile" "kops_master" {
  name = "kops-master-${local.cluster_name}"
  role = aws_iam_role.kops_master.name
}
