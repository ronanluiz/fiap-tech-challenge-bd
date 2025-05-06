locals {
  projeto = "${var.ambiente}-${var.nome_instancia}"
}

variable "regiao" {
  type    = string
  default = "us-east-1"
}

variable "ambiente" {
  type    = string
  default = "dev"
}

variable "bd_nome" {
  type = string
}

variable "instancia" {
  type    = string
  default = "db.t3.medium"
}

variable "bd_usuario" {
  type = string
}

variable "bd_senha" {
  type = string
}

variable "nome_instancia" {
  type = string
}