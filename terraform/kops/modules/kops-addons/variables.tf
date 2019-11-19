variable "cluster_id" {
  description = "KOPS cluster full name"
}

variable "state_store" {
  description = "KOPS state store s3 bucket name"	
}

variable "state_key_arn" {
  description = "KMS CMK for encrypted s3 objects in the kops state store"
}

variable "admin_users" {
  type = map
  description = "AWS IAM user arns by username"
}

variable "admin_roles" {
  type = list
  description = "Same account IAM roles"
}

variable "authenticator_config" {
  description = "Output file path for aws-iam-authenticator resources manifest"
}
