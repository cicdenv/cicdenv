resource "aws_s3_bucket" "mysql_backups" {
  bucket = "mysql-backups-${terraform.workspace}-${replace(var.domain, ".", "-")}"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        
        kms_master_key_id = aws_kms_key.mysql_backups.arn
      }
    }
  }
}
