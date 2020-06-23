output "ecr" {
  value = {
    bastion_events_worker = {
      id             = module.ecr_repo.id
      name           = module.ecr_repo.name
      arn            = module.ecr_repo.arn
      registry_id    = module.ecr_repo.registry_id
      repository_url = module.ecr_repo.repository_url
    }
  }
}
