output "autoscaling_group" {
  value = {
    id   = aws_autoscaling_group.jenkins_agents.id
    name = aws_autoscaling_group.jenkins_agents.name
    arn  = aws_autoscaling_group.jenkins_agents.arn
  }
}
