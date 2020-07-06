resource "aws_key_pair" "shared" {
  key_name   = "shared"
  public_key = base64decode(jsondecode(data.aws_secretsmanager_secret_version.shared_ssh_key.secret_string)["public-key"])
}
