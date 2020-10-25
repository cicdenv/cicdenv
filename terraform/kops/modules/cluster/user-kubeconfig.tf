data "template_file" "user_kubeconfig" {
  template = file("${path.module}/templates/kube-config.tpl")

  vars = {
    cluster_name = local.cluster_fqdn
    ca_data      = base64encode(file(local.ca_cert))
    command      = "aws-iam-authenticator"
  }
}

resource "local_file" "user_kubeconfig" {
  content  = data.template_file.user_kubeconfig.rendered
  filename = local.user_kubeconfig
}
