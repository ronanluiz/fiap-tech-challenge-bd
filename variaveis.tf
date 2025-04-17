variable "regiao" {
  type    = string
  default = "us-east-1"
}

variable "ambiente" {
  type = string
}

variable "nome_servidor_bd" {
  type = string
}

variable "nome_bd" {
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