locals {
  apt_repo_bucket_arn = data.terraform_remote_state.apt_repo.outputs.apt_repo_bucket_arn
}
