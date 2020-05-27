output "ecr" {
  value = {
    bastion_events_worker = {
      id             = aws_ecr_repository.bastion_events_worker.id
      name           = aws_ecr_repository.bastion_events_worker.name
      arn            = aws_ecr_repository.bastion_events_worker.arn
      registry_id    = aws_ecr_repository.bastion_events_worker.registry_id
      repository_url = aws_ecr_repository.bastion_events_worker.repository_url
    }
  }
}
