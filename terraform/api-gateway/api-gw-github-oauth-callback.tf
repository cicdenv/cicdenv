#
# https://jenkins.cicdenv.com/securityRealm/finishLogin
#
# A Jenkins server sends a redirect-uri to github during the OAuth flow:
#   https://jenkins.cicdenv.com/securityRealm/finishLogin/{account}/{instance}
# 'jenkins.cicdenv.com' => AWS_PROXY (lambda) integration redirecting to:
#   https://jenkins-{instance}.{account}.cicdenv.com/securityRealm/finishLogin
#

variable stage_name {
  default = "live"
}

resource "aws_api_gateway_rest_api" "jenkins_github_oauth_callbacks" {
  name        = "jenkins-github-oauth-callbacks"
  description = "Forwards github oauth callbacks to Jenkins instances"
}

resource aws_api_gateway_deployment jenkins_github_oauth_callbacks {
  depends_on = [
    aws_api_gateway_method.jenkins_github_oauth_callbacks,
    aws_api_gateway_integration.jenkins_github_oauth_callbacks,
  ]

  rest_api_id = aws_api_gateway_rest_api.jenkins_github_oauth_callbacks.id
  stage_name  = var.stage_name
}

resource aws_api_gateway_method_settings jenkins_github_oauth_callbacks_settings {
  depends_on = [
    aws_api_gateway_deployment.jenkins_github_oauth_callbacks,
  ]

  rest_api_id = aws_api_gateway_rest_api.jenkins_github_oauth_callbacks.id
  stage_name  = var.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource aws_api_gateway_domain_name jenkins_github_oauth_callbacks {
  domain_name     = "jenkins.${var.domain}"
  certificate_arn = local.wildcard_site_cert.arn
}

resource aws_api_gateway_base_path_mapping jenkins_github_oauth_callbacks {
  depends_on = [
    aws_api_gateway_deployment.jenkins_github_oauth_callbacks,
  ]

  api_id      = aws_api_gateway_rest_api.jenkins_github_oauth_callbacks.id
  domain_name = aws_api_gateway_domain_name.jenkins_github_oauth_callbacks.domain_name
  stage_name  = var.stage_name
}

resource "aws_api_gateway_resource" "jenkins_security_realm" {
  rest_api_id = aws_api_gateway_rest_api.jenkins_github_oauth_callbacks.id
  parent_id   = aws_api_gateway_rest_api.jenkins_github_oauth_callbacks.root_resource_id
  path_part   = "securityRealm"
}
resource "aws_api_gateway_resource" "jenkins_finish_login" {
  rest_api_id = aws_api_gateway_rest_api.jenkins_github_oauth_callbacks.id
  parent_id   = aws_api_gateway_resource.jenkins_security_realm.id
  path_part   = "finishLogin"
}
resource "aws_api_gateway_resource" "jenkins_account" {
  rest_api_id = aws_api_gateway_rest_api.jenkins_github_oauth_callbacks.id
  parent_id   = aws_api_gateway_resource.jenkins_finish_login.id
  path_part   = "{account}"
}
resource "aws_api_gateway_resource" "jenkins_instance" {
  rest_api_id = aws_api_gateway_rest_api.jenkins_github_oauth_callbacks.id
  parent_id   = aws_api_gateway_resource.jenkins_account.id
  path_part   = "{instance}"
}

resource "aws_api_gateway_method" "jenkins_github_oauth_callbacks" {
  rest_api_id = aws_api_gateway_rest_api.jenkins_github_oauth_callbacks.id
  resource_id = aws_api_gateway_resource.jenkins_instance.id
  http_method = "GET"

  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "response_302" {
  rest_api_id = aws_api_gateway_rest_api.jenkins_github_oauth_callbacks.id
  resource_id = aws_api_gateway_resource.jenkins_instance.id
  http_method = aws_api_gateway_method.jenkins_github_oauth_callbacks.http_method
  status_code = "302"

  response_parameters = {
    "method.response.header.Location" = true
  }
}

resource "aws_api_gateway_integration_response" "response_302" {
  depends_on = [
    aws_api_gateway_integration.jenkins_github_oauth_callbacks,
  ]
  
  rest_api_id = aws_api_gateway_rest_api.jenkins_github_oauth_callbacks.id
  resource_id = aws_api_gateway_resource.jenkins_instance.id
  http_method = aws_api_gateway_method.jenkins_github_oauth_callbacks.http_method
  status_code = aws_api_gateway_method_response.response_302.status_code

  selection_pattern = "-"

  response_parameters = {
    "method.response.header.Location" = "integration.response.body.Location"
  }
}

resource "aws_api_gateway_integration" "jenkins_github_oauth_callbacks" {
  rest_api_id = aws_api_gateway_rest_api.jenkins_github_oauth_callbacks.id
  resource_id = aws_api_gateway_resource.jenkins_instance.id
  http_method = aws_api_gateway_method.jenkins_github_oauth_callbacks.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"

  uri = aws_lambda_function.global_github_oauth_callback.invoke_arn
}
