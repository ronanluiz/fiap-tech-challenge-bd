module "dev" {
  source      = "../../shared"
  environment = "dev"
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}