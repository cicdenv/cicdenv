variable "terraform_state" {
  type = object({
    region = string  # tf s3 backend region
    bucket = string  # tf s3 backend bucket name
  })
  description = "For importing terraform states."
}

variable "ami_id" {
  type = string
  description = "AWS EC2 Machine Image (AMI) id."
}

variable "name" {
  description = "Unique Jenkins instance name."

  type = string
}

variable "instance_type" {
  description = "AWS EC2 instance type.  Supported: c5d.*, m5d*.*, r5d*.*, z1d.*, i3*"

  type = string
}

variable "executors" {
  description = "Conccurrent build job slots."

  type = number
}
