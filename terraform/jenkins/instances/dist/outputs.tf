output "type" {
  value = "distributed"
}

output "autoscaling_groups" {
  value = module.jenkins_instance.autoscaling_groups
}

output "ami" {
  value = {
    id = local.ami_id
  }
}

output "url" {
  value = "https://${module.jenkins_instance.dns.external_name}"
}
