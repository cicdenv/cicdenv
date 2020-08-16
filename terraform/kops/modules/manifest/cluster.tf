data "template_file" "etcd_members" {
  for_each = toset(local.etcd_zones)

  template = file("${path.module}/templates/etcd-member.tpl")

  vars = {
    availability_zone = each.key
    region            = local.region
    etcd_key_arn      = local.etcd_kms_key.arn
  }
}

data "template_file" "private_subnets" {
  for_each = toset(local.availability_zones)

  template = file("${path.module}/templates/subnet.tpl")

  vars = {
    availability_zone = each.key
    subnet_name       = "private-${each.key}"
    subnet_id         = local.private_subnets[each.key].id
    subnet_cidr       = local.private_subnets[each.key].cidr_block
    subnet_type       = "Private"
  }
}

data "template_file" "public_subnets" {
  for_each = toset(local.availability_zones)

  template = file("${path.module}/templates/subnet.tpl")

  vars = {
    availability_zone = each.key
    subnet_name       = "public-${each.key}"
    subnet_id         = local.public_subnets[each.key].id
    subnet_cidr       = local.public_subnets[each.key].cidr_block
    subnet_type       = "Public"
  }
}

data "template_file" "cluster_spec" {
  template = file("${path.module}/templates/cluster-spec.tpl")

  vars = {
    cluster_fqdn = local.cluster_fqdn
    state_store  = local.state_store.bucket.name
    
    kubernetes_version = local.kubernetes_version

    vpc_id           = local.vpc.id
    network_cidr     = local.network_cidr
    networking       = local.networking
    private_dns_zone = local.private_dns_zone.zone_id

    etcd_members    = join("\n", [for member in values(data.template_file.etcd_members)    : member.rendered])
    private_subnets = join("\n", [for subnet in values(data.template_file.private_subnets) : subnet.rendered])
    public_subnets  = join("\n", [for subnet in values(data.template_file.public_subnets)  : subnet.rendered])

    lb_security_groups = "[${join(",", local.api_security_groups)}]"

    audit_policy = indent(6, file("${path.module}/files/audit-policy.yaml"))

    irsa_kube_api_args = indent(4, local.irsa_kube_api_args)
  }
}
