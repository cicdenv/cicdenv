output "apt_repo_bucket" {
  value = {
    id  = aws_s3_bucket.apt_repo.id
    arn = aws_s3_bucket.apt_repo.arn
  }
}
