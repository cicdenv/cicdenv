variable "region" {}
variable "bucket" {}

variable "jenkins_instance" {
  description = "Unique Jenkins instance name."

  type = string
}

variable "executors" {
  description = "Conccurrent build job slots."

  type = number
}
  