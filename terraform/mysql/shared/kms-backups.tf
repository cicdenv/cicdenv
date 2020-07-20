resource "aws_kms_key" "mysql_backups" {
  description = "Used for MySQL dumps"
}

resource "aws_kms_alias" "mysql_backups" {
  name          = "alias/mysql-backups"
  target_key_id = aws_kms_key.mysql_backups.key_id
}
