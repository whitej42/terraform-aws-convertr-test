terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "jameswhite-terraform-state"
    key    = "terraform-aws-convertr-test/terraform.tfstate"
    region = "us-east-1"
  }
}