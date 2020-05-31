data "terraform_remote_state" "backend" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/kops_backend/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/kops_shared/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "iam_users" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/iam_users/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "pod_identity_webhook" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/shared_ecr-images_pod-identity-webhook/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "certificate_init_container" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/shared_ecr-images_certificate-init-container/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "certificate_request_approver" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/shared_ecr-images_certificate-request-approver/terraform.tfstate"
    region = var.terraform_state.region
  }
}
