data "template_file" "kube2iam_manifests" {
  template = file("${path.module}/templates/kube2iam-manifests.yaml.tpl")

  vars = {
    aws_region     = local.region
    host_interface = "cali+"
  }
}

resource "aws_s3_bucket_object" "kube2iam_manifests" {
  bucket  = local.state_store.bucket.name
  key     = "${local.cluster_fqdn}/addons/custom.kube2iam.aws/k8s-112.yaml"
  content = data.template_file.kube2iam_manifests.rendered
  
  server_side_encryption = "aws:kms"

  kms_key_id = local.state_store.key.arn
}
