## Purpose
Github Jenkins OAuth callback routing.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> github/jenkins-oauth:${WORKSPACE}
...
```

## Importing
N/A.

## Outputs
```hcl
cloudwatch_log_groups = {
  "github_oauth_callback" = {
    "arn" = "arn:aws:logs:<region>:<main-acct-id>:log-group:/aws/lambda/jenkins-github-oauth-AWS_PROXY:*"
    "name" = "/aws/lambda/jenkins-github-oauth-AWS_PROXY"
  }
}
dns = jenkins.cicdenv.com.cicdenv.com
iam = {
  "api_gateway" = {
    "role" = {
      "arn" = "arn:aws:iam::<main-acct-id>:role/api-gateway-cloudwatch"
      "name" = "api-gateway-cloudwatch"
    }
  }
  "github_oauth_callback" = {
    "policy" = {
      "arn" = "arn:aws:iam::<main-acct-id>:policy/global-github-oauth-callback"
      "name" = "global-github-oauth-callback"
      "path" = "/"
    }
    "role" = {
      "arn" = "arn:aws:iam::<main-acct-id>:role/github-oauth-global-callback"
      "name" = "github-oauth-global-callback"
    }
  }
}
lambdas = {
  "github_oauth_callback" = {
    "function_name" = "jenkins-github-oauth-AWS_PROXY"
    "handler" = "lambda.lambda_handler"
    "runtime" = "python3.7"
  }
}
```
