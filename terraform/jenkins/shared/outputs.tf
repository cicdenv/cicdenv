output "jenkins_build_records_s3_bucket" {
  value = aws_s3_bucket.jenkins_build_records.bucket
}

output "jenkins_cache_s3_bucket" {
  value = aws_s3_bucket.jenkins_cache.bucket
}

output "jenkins_key_pair" {
  value = {
    key_name = aws_key_pair.jenkins.key_name
  }
}

output "server_instance_profile" {
  value = {
    name = aws_iam_instance_profile.jenkins_server.name
    arn  = aws_iam_instance_profile.jenkins_server.arn
    role = aws_iam_instance_profile.jenkins_server.role
    path = aws_iam_instance_profile.jenkins_server.path
  }
}

output "colocated_instance_profile" {
  value = {
    name = aws_iam_instance_profile.jenkins_colo.name
    arn  = aws_iam_instance_profile.jenkins_colo.arn
    role = aws_iam_instance_profile.jenkins_colo.role
    path = aws_iam_instance_profile.jenkins_colo.path
  }
}

output "agent_instance_profile" {
  value = {
    name = aws_iam_instance_profile.jenkins_agent.name
    arn  = aws_iam_instance_profile.jenkins_agent.arn
    role = aws_iam_instance_profile.jenkins_agent.role
    path = aws_iam_instance_profile.jenkins_agent.path
  }
}

output "server_security_group" {
  value = {
    id = aws_security_group.jenkins_server.id
  }
}

output "agent_security_group" {
  value = {
    id = aws_security_group.jenkins_agent.id
  }
}

output "internal_alb_security_group" {
  value = {
    id = aws_security_group.jenkins_server_internal_alb.id
  }
}

output "external_alb_security_group" {
  value = {
    id = aws_security_group.jenkins_server_external_alb.id
  }
}

output "acm_certificate" {
  value = {
    arn = aws_acm_certificate_validation.jenkins_cert.certificate_arn
  }
}

output "persistent_config_efs" {
  value = {
    arn      = aws_efs_file_system.jenkins_persistent_config_efs.arn
    id       = aws_efs_file_system.jenkins_persistent_config_efs.id
    dns_name = aws_efs_file_system.jenkins_persistent_config_efs.dns_name
  }
}