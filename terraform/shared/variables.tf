locals {
  project  = "${var.environment}-${var.project_name}"
  vpc_name = "${var.environment}-vpc"
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

variable "project_name" {
  type    = string
  default = "tc-bd"
}