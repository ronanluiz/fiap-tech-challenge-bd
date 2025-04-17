module "dev" {
  source           = "../.."
  ambiente         = "dev"
  nome_bd          = "techchallenge"
  nome_servidor_bd = "fiap-soat10"
  bd_senha         = var.bd_usuario
  bd_usuario       = var.bd_senha
}

variable "bd_usuario" {
  type = string
}

variable "bd_senha" {
  type = string
}

output "endpoint_bd_dev" {
  value = module.dev.endpoint_bd
}
