data "template_file" "pod_identity_webhook_deployment" {
  template = file("${path.module}/templates/pod-identity-webhook/deployment.yaml.tpl")

  vars = {
    image  = local.ecr_irsa_hook_image
    initc  = local.ecr_cert_inic_image
    prefix = "irsa.amazonaws.com"  # annotation-prefix: eks.amazonaws.com
    region = local.region
  }
}

data "template_file" "pod_identity_mutating_webhook" {
  template = file("${path.module}/templates/pod-identity-webhook/mutatingwebhook.yaml.tpl")

  vars = {
    tls_cert = base64encode(file(local.ca_cert))
  }
}

data "template_file" "pod_identity_webhook" {
  template = file("${path.module}/templates/pod-identity-webhook/irsa.yaml.tpl")

  vars = {
    auth      = file("${path.module}/files/pod-identity-webhook/auth.yaml")
    service   = file("${path.module}/files/pod-identity-webhook/service.yaml")
    demonset  = data.template_file.pod_identity_webhook_deployment.rendered
    admission = data.template_file.pod_identity_mutating_webhook.rendered
  }
}

resource "aws_s3_bucket_object" "irsa_manifests" {
  bucket  = local.state_store.bucket.name
  key     = "${local.cluster_fqdn}/addons/custom.irsa.aws/k8s-116.yaml"
  content = data.template_file.pod_identity_webhook.rendered
  
  server_side_encryption = "aws:kms"

  kms_key_id = local.state_store.key.arn
  
  acl = "bucket-owner-full-control"
}
