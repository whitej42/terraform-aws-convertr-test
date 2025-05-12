variable "repo_url" {
  type        = string
  description = "GitHub repository URL"
}

variable "cidr_block" {
  type = string
  description = "Demo VPC CIDR Block"
}

variable "private_subnet_cidr" {
  type = string
  description = "Demo Private Subnet VPC CIDR Block"
}