output "ecr" {
  value = {
    id = aws_vpc_endpoint.ecr.id
  }
}
