variable "region" {}
variable "bucket" {}
variable "ami_id" {}

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
