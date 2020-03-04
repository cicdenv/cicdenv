output "kops_clusters_dynamodb_table" {
  value = {
    name     = aws_dynamodb_table.kops_clusters.name
    hash_key = aws_dynamodb_table.kops_clusters.hash_key
  }
}
