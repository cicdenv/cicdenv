resource "aws_route53_record" "jenkins_github_oauth_callback" {
  name    = aws_api_gateway_domain_name.jenkins_github_oauth_callbacks.domain_name
  type    = "A"
  zone_id = local.public_hosted_zone.id

  alias {
    name    = aws_api_gateway_domain_name.jenkins_github_oauth_callbacks.cloudfront_domain_name
    zone_id = aws_api_gateway_domain_name.jenkins_github_oauth_callbacks.cloudfront_zone_id

    evaluate_target_health = true
  }
}
