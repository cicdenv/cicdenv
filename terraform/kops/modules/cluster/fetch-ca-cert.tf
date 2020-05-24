resource "null_resource" "ca_cert_fetch" {
  triggers = {
    ca_cert     = local.ca_cert
    state_store = local.state_store.bucket.name
  }

  provisioner "local-exec" {
    command = <<EOF
id=$(kops get secret ca --name=${local.cluster_fqdn} --state=s3://${self.triggers.state_store} | tail -n+2 | awk '{print $NF}');
aws --region ${local.region} s3 cp "s3://${self.triggers.state_store}/${local.cluster_fqdn}/pki/issued/ca/$id.crt" - > "${local.ca_cert}"
EOF
  }

  provisioner "local-exec" {
    command = <<EOF
rm "${self.triggers.ca_cert}"
EOF
    when = destroy
  }

  depends_on = [
    null_resource.kops_update,
  ]
}

data "null_data_source" "wait_for_ca_cert_fetch" {
  inputs = {
    wait_for = null_resource.ca_cert_fetch.id
    ca_cert  = local.ca_cert
  }
}
