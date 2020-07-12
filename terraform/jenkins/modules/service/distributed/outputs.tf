output "autoscaling_groups" {
  value = [
    {
      id   = module.server.autoscaling_group.id
      name = module.server.autoscaling_group.name
      arn  = module.server.autoscaling_group.arn
      role = "server"
    },
    {
      id   = module.agents.autoscaling_group.id
      name = module.agents.autoscaling_group.name
      arn  = module.agents.autoscaling_group.arn
      role = "agent"
    },
  ]
}

output "dns" {
  value = module.server.dns
}
