resource aws_efs_file_system jenkins_persistent_config_efs {
  creation_token = "jenkins-persistent-config-files"

  tags = {
    Name = "Jenkins Persistent Config Files"
  }
}

resource aws_efs_mount_target jenkins_persistent_config_efs {
  for_each = local.subnets["private"]

  file_system_id = aws_efs_file_system.jenkins_persistent_config_efs.id
  subnet_id      = each.value.id

  security_groups = [
    aws_security_group.jenkins_persistent_config_efs.id,
  ]
}
