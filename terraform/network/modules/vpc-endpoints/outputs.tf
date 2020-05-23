output "s3" {
  value = {
    id = aws_vpc_endpoint.s3.id
  }
}

output "ecr" {
  value = {
    id = aws_vpc_endpoint.ecr.id
  }
}
