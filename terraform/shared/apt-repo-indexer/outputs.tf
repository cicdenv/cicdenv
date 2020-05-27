output "cloudwatch_log_groups" {
  value = {
    s3apt = {
      name = aws_cloudwatch_log_group.s3apt.name
      arn  = aws_cloudwatch_log_group.s3apt.arn
    }
  }
}

output "lambdas" {
  value = {
    s3apt = {
      function_name = aws_lambda_function.s3apt.function_name
      handler       = aws_lambda_function.s3apt.handler
      runtime       = aws_lambda_function.s3apt.runtime
    }
  }
}

output "iam" {
  value = {
    s3apt = {
      role = {
        name = aws_iam_role.s3apt.name
        arn  = aws_iam_role.s3apt.arn
      }
      policy = {
        name = aws_iam_policy.s3apt.name
        path = aws_iam_policy.s3apt.path
        arn  = aws_iam_policy.s3apt.arn
      }
    }
  }
}

output "secrets" {
  value = {
    s3apt = {
      name = aws_secretsmanager_secret.apt_repo_indexer.name
      arn  = aws_secretsmanager_secret.apt_repo_indexer.arn
    }
  }
}
