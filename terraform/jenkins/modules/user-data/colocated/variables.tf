variable "terraform_state" {
  type = object({
    region = string  # tf s3 backend region
    bucket = string  # tf s3 backend bucket name
  })
  description = "For importing terraform states."
}

variable "jenkins_instance" {
  description = "Unique Jenkins instance name."

  type = string
}

variable "executors" {
  description = "Conccurrent build job slots."

  type = number
}
  