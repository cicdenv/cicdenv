data "template_file" "csr_approver_deployment" {
  template = file("${path.module}/templates/certificate-request-approver/deployment.yaml.tpl")

  vars = {
    image = local.ecr_kapprover_image
  }
}

data "template_file" "csr_approver" {
  template = file("${path.module}/templates/certificate-request-approver/kapprover.yaml.tpl")

  vars = {
    rbac       = file("${path.module}/files/certificate-request-approver/rbac.yaml")
    sa         = file("${path.module}/files/certificate-request-approver/serviceaccount.yaml")
    deployment = data.template_file.csr_approver_deployment.rendered
    service    = file("${path.module}/files/certificate-request-approver/service.yaml")
  }
}

resource "aws_s3_bucket_object" "csr_approver" {
  bucket  = local.state_store.bucket.name
  key     = "${local.cluster_fqdn}/addons/custom.kapprover.csr/k8s-118.yaml"
  content = data.template_file.csr_approver.rendered
  
  server_side_encryption = "aws:kms"

  kms_key_id = local.state_store.key.arn
  
  acl = "bucket-owner-full-control"
}
