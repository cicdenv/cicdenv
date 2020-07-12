output "autoscaling_group" {
  value = {
    id   = aws_autoscaling_group.jenkins_server.id
    name = aws_autoscaling_group.jenkins_server.name
    arn  = aws_autoscaling_group.jenkins_server.arn
  }
}

output "ami_id" {
  value = var.ami_id
}

output "dns" {
  value = {
    external_name = "${aws_route53_record.jenkins_external_alb.name}.${local.account_hosted_zone.domain}"
    internal_name = "${aws_route53_record.jenkins_internal_alb.name}.${local.private_hosted_zone.domain}"
  }
}
