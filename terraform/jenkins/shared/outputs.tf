output "jenkins_builds_s3_bucket" {
  value = {
    id  = aws_s3_bucket.jenkins_builds.id
    arn = aws_s3_bucket.jenkins_builds.arn
  }
}

output "jenkins_key_pair" {
  value = {
    key_name = aws_key_pair.jenkins.key_name
  }
}

output "iam" {
  value = {
    server = {
      instance_profile = {
        name = aws_iam_instance_profile.jenkins_server.name
        arn  = aws_iam_instance_profile.jenkins_server.arn
        role = aws_iam_instance_profile.jenkins_server.role
        path = aws_iam_instance_profile.jenkins_server.path
      }
    }
    agent = {
      name = aws_iam_instance_profile.jenkins_agent.name
      arn  = aws_iam_instance_profile.jenkins_agent.arn
      role = aws_iam_instance_profile.jenkins_agent.role
      path = aws_iam_instance_profile.jenkins_agent.path
    }
    colocated = {
      instance_profile = {
        name = aws_iam_instance_profile.jenkins_colo.name
        arn  = aws_iam_instance_profile.jenkins_colo.arn
        role = aws_iam_instance_profile.jenkins_colo.role
        path = aws_iam_instance_profile.jenkins_colo.path
      }
    }
  }
}

output "security_groups" {
  value = {
    server = {
      id = aws_security_group.jenkins_server.id
    }
    agent = {
      id = aws_security_group.jenkins_agent.id
    }
    internal_alb = {
      id = aws_security_group.jenkins_server_internal_alb.id
    }
    external_alb = {
      id = aws_security_group.jenkins_server_external_alb.id
    }
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
