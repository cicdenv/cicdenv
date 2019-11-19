resource "null_resource" "kops_ca_cert_fetch" {
  provisioner "local-exec" {
    command = <<EOF
id=$(kops get secret ca --name=${var.cluster_name} --state=s3://${var.state_store} | tail -n+2 | awk '{print $NF}');
aws --region ${data.aws_region.current.name} s3 cp "s3://${var.state_store}/${var.cluster_name}/pki/issued/ca/$id.crt" - > "${var.kops_ca_cert}"
EOF
  }

  provisioner "local-exec" {
    command = <<EOF
rm "${var.kops_ca_cert}"
EOF
    when = destroy
  }

  depends_on = [null_resource.kops_update]
}

data "null_data_source" "wait_for_kops_ca_cert_fetch" {
  inputs = {
    wait_for     = null_resource.kops_ca_cert_fetch.id
    kops_ca_cert = var.kops_ca_cert
  }
}

data "local_file" "kops_ca_cert" {
  filename = data.null_data_source.wait_for_kops_ca_cert_fetch.outputs["kops_ca_cert"]
}
