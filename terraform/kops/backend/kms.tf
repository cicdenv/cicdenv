resource "aws_kms_key" "kops_state" {
  description = "Used for kops state store s3 objects"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": ${jsonencode(local.all_account_roots)}
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_kms_alias" "kops_state" {
  name          = "alias/kops-state"
  target_key_id = aws_kms_key.kops_state.key_id
}
