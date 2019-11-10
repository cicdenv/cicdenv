resource "aws_kms_key" "ebs" {
  description = "Used for ebs root volumes"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": ${jsonencode(local.allowed_account_roots)}
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_kms_alias" "ebs" {
  name          = "alias/ebs"
  target_key_id = aws_kms_key.ebs.key_id
}
