resource "aws_organizations_organization" "organization" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]

  feature_set = "ALL"

  provider = "aws.us-east-1"
}
