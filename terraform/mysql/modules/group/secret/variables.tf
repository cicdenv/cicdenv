variable "terraform_state" {
  type = object({
    region = string  # tf s3 backend region
    bucket = string  # tf s3 backend bucket name
  })
  description = "For importing terraform states."
}

variable "name"   {}
variable "suffix" {}
variable "desc"   {}
variable "random" {}
variable "lambda" {}
