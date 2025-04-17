resource "aws_db_instance" "bd_postgre" {
  identifier             = var.nome_servidor_bd
  allocated_storage      = 5
  storage_type           = "gp2"
  engine                 = "postgres"
  instance_class         = var.instancia
  db_name                = var.nome_bd
  username               = var.bd_usuario
  password               = var.bd_senha
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.bd.id]
  db_subnet_group_name   = aws_db_subnet_group.postgres_subnet_group.name
}


output "endpoint_bd" {
  value = aws_db_instance.bd_postgre.endpoint
}