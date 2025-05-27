locals {
  # Defina como false em produção
  skip_final_snapshot = var.environment == "prod" ? false : true
  # Defina como true em produção
  deletion_protection = var.environment == "prod"
}

resource "aws_db_instance" "bd_postgre" {
  identifier            = local.project
  engine                = "postgres"
  instance_class        = var.db_instance_type
  allocated_storage     = 5  # Em GB
  max_allocated_storage = 10 # Limite para escalonamento automático
  storage_type          = "gp2"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 5432

  publicly_accessible = true
  multi_az            = false # Defina como true para alta disponibilidade (mais caro)

  vpc_security_group_ids = [aws_security_group.bd.id]
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name

  skip_final_snapshot = local.skip_final_snapshot
  deletion_protection = local.deletion_protection

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
}


