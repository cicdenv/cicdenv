locals {
  organization = data.terraform_remote_state.accounts.outputs.organization
  
  apt_repo_bucket = data.terraform_remote_state.apt_repo.outputs.apt_repo_bucket
}
