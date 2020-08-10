output "autoscaling_group" {
  value = {
    id   = aws_autoscaling_group.wireguard.id
    name = aws_autoscaling_group.wireguard.name
    arn  = aws_autoscaling_group.wireguard.arn
  }
}

output "ami" {
  value = {
    id = local.ami_id
  }
}
