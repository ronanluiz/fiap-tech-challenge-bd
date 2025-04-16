resource "aws_security_group" "bd" {
  name   = "sg_bd"
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = "sg_bd"
  }
}

resource "aws_security_group_rule" "entrada_bd" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # permite qualquer range de ip
  security_group_id = aws_security_group.bd.id
}

resource "aws_security_group_rule" "saida_bd" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # permite qualquer protocolo
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bd.id
}