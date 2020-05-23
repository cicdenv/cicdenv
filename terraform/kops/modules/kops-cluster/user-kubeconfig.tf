module "kops_user_kubeconfig" {
  source = "../kops-user-kubeconfig"

  cluster_name = var.cluster_name

  kops_ca_cert    = data.null_data_source.wait_for_kops_ca_cert_fetch.outputs["kops_ca_cert"]
  user_kubeconfig = var.user_kubeconfig
}
