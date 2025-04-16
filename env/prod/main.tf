module "prod" {
  source          = "../.."
  ambiente        = "prod"
  nome_banco_dados = "techchallange_bd_prod"
}

output "endpoint_bd_prod" {
  value = module.prod.endpoint_bd
}