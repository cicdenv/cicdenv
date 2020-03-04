resource "aws_dynamodb_table_item" "s3_vpc_endpoint" {
  table_name = "vpc-endpoints"
  hash_key   = "VPCeID"

  item = <<EOF
{
  "VPCeID": {"S": "${aws_vpc_endpoint.s3.id}"}
}
EOF

  provider = aws.main
}
