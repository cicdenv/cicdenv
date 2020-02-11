data "template_file" "user_kubeconfig" {
  template = file("${path.module}/templates/kube-config.tpl")

  vars = {
    cluster_name = var.cluster_name
    ca_data      = base64encode(file(var.kops_ca_cert))
    command      = var.authenticator_command
  }
}

resource "local_file" "user_kubeconfig" {
  content  = data.template_file.user_kubeconfig.rendered
  filename = var.user_kubeconfig
}
