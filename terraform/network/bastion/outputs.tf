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

output "iam" {
  value = {
    bastion_service = module.bastion.iam
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
  }
}

output "autoscaling_group" {
  value = module.bastion.autoscaling_group
}

output "dns" {
  value = module.bastion.dns
}

output "nlb" {
  value = module.bastion.nlb
}
