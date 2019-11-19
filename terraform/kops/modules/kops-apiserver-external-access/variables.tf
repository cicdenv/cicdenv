variable "cluster_short_name" {
  description = "Short cluster name"
}

variable "vpc_id" {
  description = "KOPS VPC from the 'static' state."
}

variable "public_subnet_ids" {
  description = "KOPS VPC public subnets from the 'static' state."
  type = list
}

variable "master_asg_names" {
  description = "Master Auto Scaling Group names list (1 per AZ)."
  type = list
}

variable "apiserver_security_group_id" {
  description = "External API server security group"
}

variable "zone_id" {
  description = "Hosted zone for lb dns alias record."
}
