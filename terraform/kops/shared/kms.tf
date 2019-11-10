resource "aws_kms_key" "kops_etcd" {
  description = "Used for for encrypting etcd EBS volumes"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_kms_alias" "kops_etcd" {
  name          = "alias/kops-etcd"
  target_key_id = aws_kms_key.kops_etcd.key_id
}
