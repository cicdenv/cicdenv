variable "terraform_state" {
  type = object({
    region = string  # tf s3 backend region
    bucket = string  # tf s3 backend bucket name
  })
  description = "For importing terraform states."
}

variable "name" {
  description = "MySQL group name."

  type = string
}

variable "id" {
  description = "MySQL group member instance id."

  type = string
}

variable "ami_id" {
  type = string
  description = "AWS EC2 Machine Image (AMI) id."
}

variable "instance_type" {
  description = "AWS EC2 instance type.  Supported: m5dn*.*, r5dn*.*, i3en*"

  type = string
}
