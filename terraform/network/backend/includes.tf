data "aws_region" "current" {}
data "aws_availability_zones" "azs" {}

data "aws_vpc_endpoint_service" "ecr" {
  service = "ecr.api"
}
