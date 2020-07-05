locals {
  network_cidr = "10.16.0.0/16"

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
    "SubnetType"             = "Utility"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "SubnetType"                      = "Private"
  }

  cluster_tags = zipmap(data.null_data_source.cluster_tags.*.outputs.Key,
                        data.null_data_source.cluster_tags.*.outputs.Value)

  # Limit AZs to no more than 3
  availability_zones = split(",", length(data.aws_availability_zones.azs.names) > 3 ? 
      join(",", slice(data.aws_availability_zones.azs.names, 0, 3)) 
    : join(",", data.aws_availability_zones.azs.names))

  apt_repo_policy = data.terraform_remote_state.iam_common_policies.outputs.iam.apt_repo.policy
  
  assume_role = data.terraform_remote_state.iam_assumed_roles.outputs.iam.identity_resolver.role
 
  ecr_bastion_sshd_worker   = data.terraform_remote_state.ecr_bastion_sshd_worker.outputs.ecr.bastion_sshd_worker
  ecr_bastion_events_worker = data.terraform_remote_state.ecr_bastion_events_worker.outputs.ecr.bastion_events_worker

  iam_user_updates_sns_topic = data.terraform_remote_state.iam_events.outputs.sns.topics.iam_user_updates
  
  event_subscriber_function_name = "event-subscriber-bastion-service"
  ssh_keys_function_name         = "shared-ec2-keypair-generator"
}
