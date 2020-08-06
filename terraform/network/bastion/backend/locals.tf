locals {
  vpc = data.terraform_remote_state.network_backend.outputs.vpc
  
  subnets = data.terraform_remote_state.network_backend.outputs.subnets

  apt_repo_policy = data.terraform_remote_state.iam_common_policies.outputs.iam.apt_repo.policy
  
  lambda_bucket = data.terraform_remote_state.lambda.outputs.lambda.bucket

  assume_role = data.terraform_remote_state.iam_assumed_roles.outputs.iam.identity_resolver.role
 
  ecr_bastion_sshd_worker   = data.terraform_remote_state.ecr_bastion_sshd_worker.outputs.ecr.bastion_sshd_worker
  ecr_bastion_events_worker = data.terraform_remote_state.ecr_bastion_events_worker.outputs.ecr.bastion_events_worker

  iam_user_updates_sns_topic = data.terraform_remote_state.iam_events.outputs.sns.topics.iam_user_updates
  event_subscriber_function_name = "event-subscriber-bastion-service"
  event_subscriber_lambda_key    = "functions/${local.event_subscriber_function_name}.zip"
}
