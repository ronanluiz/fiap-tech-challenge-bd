terraform {
  backend "s3" {
    bucket = "tech-challenge-soat10-fase3"
    key    = "terraform/prod/bd/terraform.tfstate"
    region = "us-east-1"
  }
}
