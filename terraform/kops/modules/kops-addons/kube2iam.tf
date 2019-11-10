data "template_file" "kube2iam_manifests" {
  template = file("${path.module}/templates/kube2iam-manifests.yaml.tpl")

  vars = {
    aws_region     = data.aws_region.current.name
    host_interface = "cali+"
  }
}

resource "aws_s3_bucket_object" "kube2iam_manifests" {
  bucket  = var.state_store
  key     = "${var.cluster_id}/addons/custom.kube2iam.aws/k8s-112.yaml"
  content = data.template_file.kube2iam_manifests.rendered
  
  server_side_encryption = "aws:kms"
  kms_key_id             = var.state_key_arn
}
