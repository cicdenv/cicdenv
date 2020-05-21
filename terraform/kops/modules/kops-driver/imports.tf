data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/kops_shared/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "backend" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/kops-backend/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "iam_admins" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam_admins/terraform.tfstate"
    region = var.region
  }
}
