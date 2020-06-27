data "external" "vpc-endpoints" {
  program = ["${path.module}/../../data/external/dynamodb-scan-for-attribute.py"]

  query = {
    dynamodb_table = "vpc-endpoints"
    attribute      = "VPCeID"
  }
}
