data "aws_secretsmanager_secret" "shared_ssh_key" {
  name = local.shared_ec2_keypair.name
}

data "aws_secretsmanager_secret_version" "shared_ssh_key" {
  secret_id     = data.aws_secretsmanager_secret.shared_ssh_key.id
  version_stage = "AWSCURRENT"
}
