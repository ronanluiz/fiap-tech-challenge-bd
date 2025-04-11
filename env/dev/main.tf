module "dev" {
  source          = "../.."
  environment     = "dev"
  database_name = "techchallange_bd_dev"
}

# output "alb_techchallenge_ip" {
#   value = module.prod.alb_dns_name
# }
