resource "aws_security_group" "events" {
  name   = "bastion-events"
  vpc_id = local.vpc.id

  description = "Bastion events"
      
  tags = {
    Name = "bastion-events"
  }
}

resource "aws_security_group_rule" "events_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.events.id
  cidr_blocks       = ["0.0.0.0/0"]
}
