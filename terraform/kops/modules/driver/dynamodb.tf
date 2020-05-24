resource "aws_dynamodb_table_item" "cluster_entry" {
  table_name = "kops-clusters"
  hash_key   = "FQDN"

  item = <<EOF
{
  "FQDN": {"S": "${local.cluster_name}"}
}
EOF
}
