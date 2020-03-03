output "autoscaling_groups" {
  value = [
    {
      id   = module.colocated.autoscaling_group.id
      name = module.colocated.autoscaling_group.name
      arn  = module.colocated.autoscaling_group.arn
    },
  ]
}
