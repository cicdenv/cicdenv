output "bastion_service" {
  value = {
    security_group = {
      id = aws_security_group.bastion.id
    }
  }
}

output "bastion_events" {
  value = {
    security_group = {
      id = aws_security_group.events.id
    }
  }
}

output "iam" {
  value = {
    iam_user_event_subscriber = {
      role = {
        name = aws_iam_role.iam_user_event_subscriber.name
        arn  = aws_iam_role.iam_user_event_subscriber.arn
      }
      policy = {
        name = aws_iam_policy.iam_user_event_subscriber.name
        path = aws_iam_policy.iam_user_event_subscriber.path
        arn  = aws_iam_policy.iam_user_event_subscriber.arn
      }
    }
    bastion = {
      role = {
        name = aws_iam_role.bastion.name
        arn  = aws_iam_role.bastion.arn
      }
      policy = {
        name = aws_iam_policy.bastion.name
        path = aws_iam_policy.bastion.path
        arn  = aws_iam_policy.bastion.arn
      }
      instance_profile = {
        arn = aws_iam_instance_profile.bastion.arn
      }
    }
  }
}

output "cloudwatch_log_groups" {
  value = {
    iam_user_event_subscriber = {
      name = aws_cloudwatch_log_group.iam_user_event_subscriber.name
      arn  = aws_cloudwatch_log_group.iam_user_event_subscriber.arn
    }
  }
}

output "lambdas" {
  value = {
    iam_user_event_subscriber = {
      function_name = aws_lambda_function.iam_user_event_subscriber.function_name
      handler       = aws_lambda_function.iam_user_event_subscriber.handler
      runtime       = aws_lambda_function.iam_user_event_subscriber.runtime
      vpc_config    = aws_lambda_function.iam_user_event_subscriber.vpc_config
    }
  }
}
