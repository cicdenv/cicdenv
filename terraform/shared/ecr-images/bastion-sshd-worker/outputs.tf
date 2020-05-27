output "ecr" {
  value = {
    bastion_sshd_worker = {
      id             = aws_ecr_repository.bastion_sshd_worker.id
      name           = aws_ecr_repository.bastion_sshd_worker.name
      arn            = aws_ecr_repository.bastion_sshd_worker.arn
      registry_id    = aws_ecr_repository.bastion_sshd_worker.registry_id
      repository_url = aws_ecr_repository.bastion_sshd_worker.repository_url
    }
  }
}
