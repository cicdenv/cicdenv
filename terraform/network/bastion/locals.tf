locals {
  vpc_id  = data.terraform_remote_state.network.outputs.vpc.id
  subnets = data.terraform_remote_state.network.outputs.subnets

  zone_id = data.terraform_remote_state.domains.outputs.account_public_zone.zone_id

  assume_role = data.terraform_remote_state.iam_assumed_roles.outputs.iam.identity_resolver.role

  security_groups = {
    bastion = data.terraform_remote_state.network.outputs.bastion_service.security_group
    events  = data.terraform_remote_state.network.outputs.bastion_events.security_group
  }
  
  iam_user_updates_sns_topic = data.terraform_remote_state.iam_events.outputs.sns.topics.iam_user_updates

  ami_id = var.base_ami_id != "" ? var.base_ami_id : data.terraform_remote_state.amis.outputs.base_ami.id

  event_subscriber_function_name = "event-subscriber-bastion-service"
}
