resource "aws_security_group" "mysql_group" {
  name   = "mysql-${var.name}"
  vpc_id = local.vpc_id

  description = "mysql ${var.name} member server"
      
  tags = {
    Name = "mysql-${var.name}"
  }
}

resource "aws_security_group_rule" "mysql_group_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.mysql_group.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "mysql_group_clients" {
  description = "mysql ${var.name} client access"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 3306
  to_port     = 3306

  security_group_id = aws_security_group.mysql_group.id
  cidr_blocks       = ["0.0.0.0/0"]
}
