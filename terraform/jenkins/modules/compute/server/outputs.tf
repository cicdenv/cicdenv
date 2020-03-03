output "autoscaling_group" {
  value = {
    id   = aws_autoscaling_group.jenkins_server.id
    name = aws_autoscaling_group.jenkins_server.name
    arn  = aws_autoscaling_group.jenkins_server.arn
  }
}
