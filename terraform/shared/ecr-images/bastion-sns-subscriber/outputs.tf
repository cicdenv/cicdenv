output "bastion_sns_subscriber_image_repo" {
  value = {
    id             = aws_ecr_repository.bastion_sns_subscriber.id
    name           = aws_ecr_repository.bastion_sns_subscriber.name
    arn            = aws_ecr_repository.bastion_sns_subscriber.arn
    registry_id    = aws_ecr_repository.bastion_sns_subscriber.registry_id
    repository_url = aws_ecr_repository.bastion_sns_subscriber.repository_url
  }
}
