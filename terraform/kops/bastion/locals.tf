locals {
  vpc_id          = data.terraform_remote_state.shared.outputs.vpc_id
  public_subnets  = data.terraform_remote_state.shared.outputs.public_subnet_ids
  private_subnets = data.terraform_remote_state.shared.outputs.private_subnet_ids

  zone_id = data.terraform_remote_state.domains.outputs.kops_public_zone_id

  assume_role_arn = data.terraform_remote_state.iam_assumed_roles.outputs.identity_resolver_role_arn

  security_group = data.terraform_remote_state.shared.outputs.bastion_service_security_group_id
  
  events_security_group = data.terraform_remote_state.shared.outputs.bastion_events_security_group_id

  iam_user_updates_sns_topic = data.terraform_remote_state.iam_events.outputs.iam_user_updates_sns_topic

  event_subscriber_function_name = "event-subscriber-KOPS-BASTION"

  ami_id = var.base_ami_id != "" ? var.base_ami_id : data.terraform_remote_state.amis.outputs.base_ami.id
}
