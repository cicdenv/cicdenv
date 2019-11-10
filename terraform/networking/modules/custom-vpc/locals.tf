locals {
  # Use a restricted set of AZs if desired
  availability_zones = split(",", length(var.availability_zones) != 0 ? 
      join(",", var.availability_zones) 
    : join(",", data.aws_availability_zones.azs.names)
  )
}
