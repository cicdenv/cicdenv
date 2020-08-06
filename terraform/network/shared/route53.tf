#
# Available in AWS provider 3.1
# https://github.com/terraform-providers/terraform-provider-aws/milestone/145
#   https://github.com/terraform-providers/terraform-provider-aws/pull/14215
#
# cicdctl terraform import network/shared:$acct aws_route53_vpc_association_authorization.private <zone-id>:<vpc-id>
# cicdctl terraform import network/shared:dev   aws_route53_vpc_association_authorization.private Z09584783MN38AXNFF0H2:vpc-066d0dca7d6b816bc
# cicdctl terraform import network/shared:test  aws_route53_vpc_association_authorization.private Z09584783MN38AXNFF0H2:vpc-0726e220de37d49fe
# cicdctl terraform import network/shared:prod  aws_route53_vpc_association_authorization.private Z09584783MN38AXNFF0H2:vpc-085c6f0959b852a74
# cicdctl terraform import network/shared:infra aws_route53_vpc_association_authorization.private Z09584783MN38AXNFF0H2:vpc-0dfe8afb70d700392
#
#resource "aws_route53_vpc_association_authorization" "private" {
#  count = terraform.workspace != "main" ? 1 : 0  # only for cross account
#
#  zone_id = local.private_hosted_zone.zone_id
#  vpc_id  = module.shared_vpc.vpc.id
#
#  vpc_region = var.target_region
#  
#  provider = aws.main
#}
#

resource "aws_route53_zone_association" "private" {
  count = terraform.workspace == "main" ? 1 : 0 # remove when 3.1 AWS Provider

  zone_id = local.private_hosted_zone.zone_id
  vpc_id  = module.shared_vpc.vpc.id
}
