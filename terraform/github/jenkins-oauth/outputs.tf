output "cloudwatch_log_groups" {
  value = {
    github_oauth_callback = {
      name = aws_cloudwatch_log_group.github_oauth_callback.name
      arn  = aws_cloudwatch_log_group.github_oauth_callback.arn
    }
  }
}

output "lambdas" {
  value = {
    github_oauth_callback = {
      function_name = aws_lambda_function.github_oauth_callback.function_name
      handler       = aws_lambda_function.github_oauth_callback.handler
      runtime       = aws_lambda_function.github_oauth_callback.runtime
    }
  }
}

output "dns" {
  value = aws_route53_record.jenkins_github_oauth_callback.name
}

output "iam" {
  value = {
    api_gateway = {
      role = {
        name = aws_iam_role.api_gateway_cloudwatch.name
        arn  = aws_iam_role.api_gateway_cloudwatch.arn
      }
    }
    github_oauth_callback = {
      role = {
        name = aws_iam_role.github_oauth_callback.name
        arn  = aws_iam_role.github_oauth_callback.arn
      }
      policy = {
        name = aws_iam_policy.github_oauth_callback.name
        path = aws_iam_policy.github_oauth_callback.path
        arn  = aws_iam_policy.github_oauth_callback.arn
      }
    }
  }
}
