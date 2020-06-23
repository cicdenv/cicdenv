variable "name" {
  description = "ECR Repository Name."
}

variable "terraform_state" {
  type = object({
    region = string  # tf s3 backend region
    bucket = string  # tf s3 backend bucket name
  })
  description = "For importing terraform states."
}

variable "subaccount_permissions" {
  default = "r"
  description = "Organization Account access: r|rw"
}
