data "aws_region" "current" {}

data "aws_secretsmanager_secret" "shared_ssh_key" {
  name = local.shared_key_pair.key_name
}
data "aws_secretsmanager_secret_version" "shared_ssh_key" {
  secret_id     = "${data.aws_secretsmanager_secret.shared_ssh_key.id}"
  version_stage = "AWSCURRENT"
}
