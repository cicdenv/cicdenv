## Purpose
NAT gateways enable private subnets to access networks outside the VPC.

They are relatively expensive ~ $50 per month, per AZ.

Its useful to define them in a different component than the parent VPC so
they can be destroyed separately.
