resource "aws_kms_key" "terraform" {
  description = "Used for terraform state"
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
