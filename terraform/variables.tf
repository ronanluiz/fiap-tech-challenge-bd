locals {
  project  = "${var.environment}-tc-bd"
  vpc_name = "tc-soat10-vpc"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "db_name" {
  type = string
}

variable "db_instance_type" {
  type    = string
  default = "db.t3.medium"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}