locals {
  etcd_zones = length(var.availability_zones) % 2 == 0 ? length(var.availability_zones) - 1 : length(var.availability_zones)
}
