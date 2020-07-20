locals {
  apt_repo_policy = data.terraform_remote_state.iam_common_policies.outputs.iam.apt_repo.policy

  vpc_id = data.terraform_remote_state.network.outputs.vpc.id

  mysql_backups = data.terraform_remote_state.shared.outputs.mysql_backups
}
