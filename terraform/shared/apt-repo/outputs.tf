output "apt_repo_bucket" {
  value = {
    id  = aws_s3_bucket.apt_repo.id
    arn = aws_s3_bucket.apt_repo.arn
  }
}

output "cloudwatch_log_groups" {
  value = {
    indexer = {
      name = aws_cloudwatch_log_group.indexer.name
      arn  = aws_cloudwatch_log_group.indexer.arn
    }
    gpg = {
      name = aws_cloudwatch_log_group.gpg.name
      arn  = aws_cloudwatch_log_group.gpg.arn
    }
  }
}

output "lambdas" {
  value = {
    indexer = {
      function_name = aws_lambda_function.indexer.function_name
      handler       = aws_lambda_function.indexer.handler
      runtime       = aws_lambda_function.indexer.runtime
    }
    gpg = {
      function_name = aws_lambda_function.gpg.function_name
      handler       = aws_lambda_function.gpg.handler
      runtime       = aws_lambda_function.gpg.runtime
    }
  }
}

output "iam" {
  value = {
    indexer = {
      role = {
        name = aws_iam_role.indexer.name
        arn  = aws_iam_role.indexer.arn
      }
      policy = {
        name = aws_iam_policy.indexer.name
        path = aws_iam_policy.indexer.path
        arn  = aws_iam_policy.indexer.arn
      }
    }
    gpg = {
      role = {
        name = aws_iam_role.gpg.name
        arn  = aws_iam_role.gpg.arn
      }
      policy = {
        name = aws_iam_policy.gpg.name
        path = aws_iam_policy.gpg.path
        arn  = aws_iam_policy.gpg.arn
      }
    }
  }
}

output "secrets" {
  value = {
    gpg = {
      name = aws_secretsmanager_secret.gpg.name
      arn  = aws_secretsmanager_secret.gpg.arn
    }
  }
}
