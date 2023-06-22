# Create a name variable
variable "name" {
  type = string
}

# Create a service_account_name variable
variable "service_account_name" {
  type    = string
  default = ""
}

# Create a region variable
variable "region" {
  type    = string
  default = "eu-central-1"
}

# Configure the AWS Provider
provider "aws" {
  region  = var.region
}

terraform {
  required_version = ">= 1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Create private Bucket With Tags
resource "aws_s3_bucket" "example" {
  bucket = var.name

  tags = {
    Name        = "Hubctl bucket"
    Environment = "Dev"
  }
}
