output "ecr" {
  value = {
    id  = aws_vpc_endpoint.ecr.id
    arn = aws_vpc_endpoint.ecr.arn

    service_name = aws_vpc_endpoint.ecr.service_name
  }
}
