resource "aws_s3_bucket" "jenkins_build_records" {
  bucket = "jenkins-build-records-${terraform.workspace}-${replace(var.domain, ".", "-")}"
  acl    = "private"

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "jenkins_cache" {
  bucket = "jenkins-cache-${terraform.workspace}-${replace(var.domain, ".", "-")}"
  acl    = "private"

  versioning {
    enabled    = true
    mfa_delete = false
  }
}
