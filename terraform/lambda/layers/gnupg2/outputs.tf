output "layer" {
  value = {
    id           = aws_lambda_layer_version.this.id
    arn          = aws_lambda_layer_version.this.arn
    layer_name   = aws_lambda_layer_version.this.layer_name
    license_info = aws_lambda_layer_version.this.license_info
    version      = aws_lambda_layer_version.this.version

    compatible_runtimes = aws_lambda_layer_version.this.compatible_runtimes
  }
}
