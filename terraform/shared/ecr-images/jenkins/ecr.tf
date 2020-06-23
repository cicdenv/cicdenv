module "ecr_jenkins_server" {
  source = "../modules/ecr-repo"

  name = "jenkins-server"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }
}

module "ecr_jenkins_agent" {
  source = "../modules/ecr-repo"

  name = "jenkins-agent"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }
}

module "ecr_ci_builds" {
  source = "../modules/ecr-repo"

  name = "ci-builds"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }

  subaccount_permissions = "rw"
}
