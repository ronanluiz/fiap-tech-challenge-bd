terraform {
  backend "s3" {
    bucket = "fiap-soat10-tc-fase3-0525"
    key    = "terraform/bd-prod/terraform.tfstate"
    region = "us-east-1"
  }
}
