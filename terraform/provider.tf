terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.regiao

  default_tags {
    tags = {
      environment = var.ambiente
      terraform   = "true"
    }
  }
}