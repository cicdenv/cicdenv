resource "random_string" "random" {
  length = 4
}

module "tls_keys" {
  source = "./secret"

  name   = var.name
  suffix = "tls"
  desc   = "keys"
  random = random_string.random.result

  filename = "${path.module}/../../shared/tls-function/lambda.zip"
}

module "credentials" {
  source = "./secret"

  name   = var.name
  suffix = "creds"
  desc   = "passwords"
  random = random_string.random.result

  filename = "${path.module}/../../shared/creds-function/lambda.zip"
}
