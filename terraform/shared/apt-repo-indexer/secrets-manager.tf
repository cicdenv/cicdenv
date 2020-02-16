resource "aws_secretsmanager_secret" "apt_repo_indexer" {
  name = "apt-repo-indexer"

  description = "S3 apt repository indexer gpg secrets"
}
