locals {
  host_name = "bastion-${terraform.workspace}"

  apt_repo_policy = data.terraform_remote_state.iam_common_policies.outputs.iam.apt_repo.policy
  
  ecr_bastion_sshd_worker   = data.terraform_remote_state.ecr_bastion_sshd_worker.outputs.ecr.bastion_sshd_worker
  ecr_bastion_events_worker = data.terraform_remote_state.ecr_bastion_events_worker.outputs.ecr.bastion_events_worker

  account_hosted_zone = {
    domain = replace(data.aws_route53_zone.account_hosted_zone.name, "/\\.$/", "")
  }
}
