data "aws_caller_identity" "current" {}

locals {
  aws_region = "us-east-1"
  account_id = data.aws_caller_identity.current.account_id
  env = "dev"

  default_tags = {
    Terraform = true
    Project = var.repo_url
    Environment = "Development"
  }
}
