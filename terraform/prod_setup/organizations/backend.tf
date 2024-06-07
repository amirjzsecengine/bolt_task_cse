provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket         = "bolt-task-terraform-state-bucket"
    key            = "setup/prod/oragnizations/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
  }
}
