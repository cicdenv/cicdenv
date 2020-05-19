resource "aws_cloudwatch_log_group" "cloudtrail" {
  name = "cloudtrail-events"
  
  retention_in_days = 90
}
