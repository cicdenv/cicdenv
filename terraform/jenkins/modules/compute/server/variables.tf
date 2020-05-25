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

variable "jenkins_instance" {
  description = "Unique Jenkins service name"

  type = string
}

variable "instance_type" {
  description = "AWS EC2 instance-type"

  type = string
}

variable "user_data" {
  type = string
}

variable "instance_profile_arn" {
  type = string
}
