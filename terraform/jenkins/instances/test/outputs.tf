output "type" {
  value = "colocated"
}

output "autoscaling_groups" {
  value = module.jenkins_instance.autoscaling_groups
}
