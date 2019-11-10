#
# Terraform backend settings
#   Used by all states
#
region         = "us-west-2"
bucket         = "terraform.cicdenv.com"
acl            = "bucket-owner-full-control"
dynamodb_table = "terraform-state-lock"
kms_key_id     = "arn:aws:kms:us-west-2:014719181291:key/c4e8296c-028b-412e-85ac-7c302364fe9b" # alias/terraform-state
encrypt        = true
