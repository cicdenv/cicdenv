output "autoscaling_group" {
  value = {
    id   = aws_autoscaling_group.bastion.id
    name = aws_autoscaling_group.bastion.name
    arn  = aws_autoscaling_group.bastion.arn
  }
}

output "ami" {
  value = {
    id = local.ami_id
  }
}
