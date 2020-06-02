data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/network_shared/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "routing" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/network_routing/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "amis" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_packer/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "iam_assumed_roles" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam_assumed-roles/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "ecr_bastion_sshd_worker" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_ecr-images_bastion-sshd-worker/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "ecr_bastion_events_worker" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_ecr-images_bastion-events-worker/terraform.tfstate"
    region = var.region
  }
}
