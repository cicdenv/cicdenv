output "topology" {
  value = {for az, nat_gateway in aws_nat_gateway.nat_gw : az => {
    id = nat_gateway.id
    ip = nat_gateway.public_ip
  }}
}
