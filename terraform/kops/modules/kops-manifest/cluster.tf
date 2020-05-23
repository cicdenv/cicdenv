data "template_file" "kops_etcd_members" {
  for_each = toset(local.etcd_zones)

  template = file("${path.module}/templates/etcd-member.tpl")

  vars = {
    availability_zone = each.key
    region            = data.aws_region.current.name
    etcd_key_arn      = var.etcd_kms_key.arn
  }
}

data "template_file" "kops_private_subnets" {
  for_each = toset(var.availability_zones)

  template = file("${path.module}/templates/subnet.tpl")

  vars = {
    availability_zone = each.key
    subnet_name       = "private-${each.key}"
    subnet_id         = var.private_subnets[each.key].id
    subnet_cidr       = var.private_subnets[each.key].cidr_block
    subnet_type       = "Private"
  }
}

data "template_file" "kops_public_subnets" {
  for_each = toset(var.availability_zones)

  template = file("${path.module}/templates/subnet.tpl")

  vars = {
    availability_zone = each.key
    subnet_name       = "utility-${each.key}"
    subnet_id         = var.public_subnets[each.key].id
    subnet_cidr       = var.public_subnets[each.key].cidr_block
    subnet_type       = "Utility"
  }
}

data "template_file" "kops_cluster_spec" {
  template = file("${path.module}/templates/cluster-spec.tpl")

  vars = {
    cluster_name = var.cluster_name
    state_store  = var.state_store.bucket.name
    
    kubernetes_version = var.kubernetes_version

    vpc_id           = var.vpc_id
    network_cidr     = var.network_cidr
    networking       = var.networking
    private_dns_zone = var.private_dns_zone

    etcd_members    = join("\n", values(data.template_file.kops_etcd_members).*.rendered)
    private_subnets = join("\n", values(data.template_file.kops_private_subnets).*.rendered)
    public_subnets  = join("\n", values(data.template_file.kops_public_subnets).*.rendered)

    lb_security_groups = length(var.internal_apiserver_security_groups) == 0 ? "[]": "[${join(",", var.internal_apiserver_security_groups)}]"

    audit_policy = indent(6, file("${path.module}/files/audit-policy.yaml"))
  }
}
