module "prod" {
  source      = "../../shared"
  environment = "prod"
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}