data "aws_vpc" "vpc" {
  tags = {
    Name = local.vpc_name
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = {
    tier = "public"
  }
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "${local.project}-subnet-group"
  subnet_ids = data.aws_subnets.public_subnets.ids

  tags = {
    Name = "Postgres Subnet Group"
  }
}

resource "aws_security_group" "bd" {
  name   = "${local.project}-sg"
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = "${local.project}-sg"
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # permite qualquer range de ip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # permite qualquer protocolo
    cidr_blocks = ["0.0.0.0/0"]
  }
}