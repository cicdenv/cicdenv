output "autoscaling_groups" {
  value = {for az in local.availability_zones : az => {
    id   = aws_autoscaling_group.redis_node[az].id
    name = aws_autoscaling_group.redis_node[az].name
    arn  = aws_autoscaling_group.redis_node[az].arn
  }}
}
