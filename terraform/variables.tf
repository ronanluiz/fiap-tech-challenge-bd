locals {
  projeto = "${var.ambiente}-tc-bd"
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