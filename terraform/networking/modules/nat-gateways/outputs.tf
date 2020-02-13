output "ids" {
  value = aws_nat_gateway.nat_gw.*.id
}

output "ips" {
  value = aws_nat_gateway.nat_gw.*.public_ip
}
