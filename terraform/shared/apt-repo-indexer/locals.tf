locals {
  apt_repo_bucket     = data.terraform_remote_state.apt_repo.outputs.apt_repo_bucket
  apt_repo_bucket_arn = data.terraform_remote_state.apt_repo.outputs.apt_repo_bucket_arn
}
