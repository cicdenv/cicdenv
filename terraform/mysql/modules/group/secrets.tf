resource "random_string" "random" {
  length = 4
}

module "tls_keys" {
  source = "./secret"

  name   = var.name
  suffix = "tls"
  desc   = "keys"
  random = random_string.random.result
  lambda = "mysql-tls-generator"

  terraform_state = {
    region = var.terraform_state.region
    bucket = var.terraform_state.bucket
  }
}

module "credentials" {
  source = "./secret"

  name   = var.name
  suffix = "creds"
  desc   = "passwords"
  random = random_string.random.result
  lambda = "mysql-creds-generator"

  terraform_state = {
    region = var.terraform_state.region
    bucket = var.terraform_state.bucket
  }
}
