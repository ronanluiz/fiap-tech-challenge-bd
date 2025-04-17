data "aws_vpc" "vpc" {
  tags = {
    Name = "vpc-techchallenge"
  }
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "bd-subnet-group"
  subnet_ids = data.aws_subnets.subnets.ids

  tags = {
    Name = "Postgres Subnet Group"
  }
}


