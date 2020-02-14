output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cidr_block" {
  value = local.network_cidr
}

output "availability_zones" {
  value = local.availability_zones
}

output "s3_vpc_endpoint_id" {
  value = module.vpc.s3_vpc_endpoint_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "private_dns_zone" {
  value = aws_route53_zone.private.zone_id
}

output "bastion_service_security_group_id" {
  value = aws_security_group.bastion.id
}

output "nodes_security_group_id" {
  value = aws_security_group.kops_nodes.id
}

output "masters_security_group_id" {
  value = aws_security_group.kops_masters.id
}

output "internal_apiserver_security_group_id" {
  value = aws_security_group.kops_internal_apiserver.id
}

output "external_apiserver_security_group_id" {
  value = aws_security_group.kops_external_apiserver.id
}

output "masters_role_arn" {
  value = aws_iam_role.kops_master.arn
}

output "masters_role_name" {
  value = aws_iam_role.kops_master.name
}

output "master_instance_profile_arn" {
  value = aws_iam_instance_profile.kops_master.arn
}

output "nodes_role_arn" {
  value = aws_iam_role.kops_node.arn
}

output "nodes_role_name" {
  value = aws_iam_role.kops_node.name
}

output "nodes_instance_profile_arn" {
  value = aws_iam_instance_profile.kops_node.arn
}

output "cluster_names" {
  value = local.cluster_names
}

output "public_subnet_tags" {
  value = merge(local.cluster_tags, local.public_subnet_tags)
}

output "private_subnet_tags" {
  value = merge(local.cluster_tags, local.private_subnet_tags)
}

output "etcd_key_arn" {
  value = aws_kms_key.kops_etcd.arn
}

output "etcd_key_alias" {
  value = aws_kms_alias.kops_etcd.name
}
