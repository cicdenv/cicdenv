locals {
  host_name = "bastion-${terraform.workspace}"

  apt_repo_policy_arn = data.terraform_remote_state.iam_common_policies.outputs.apt_repo_policy_arn
  
  ecr_bastion_sshd_worker_arn = data.terraform_remote_state.ecr_bastion_sshd_worker.outputs.bastion_sshd_worker_image_repo.arn
  ecr_bastion_sshd_worker_url = data.terraform_remote_state.ecr_bastion_sshd_worker.outputs.bastion_sshd_worker_image_repo.repository_url
}
