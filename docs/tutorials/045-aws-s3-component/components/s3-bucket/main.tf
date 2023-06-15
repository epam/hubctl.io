variable "name" {
  type = string
}

variable "service_account_name" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = "us-east-1"
}


variable "aws_profile" {
  type    = string
  default = "fullAccessS3"
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

provider "aws" {
  region = var.region
  profile = var.aws_profile
}

locals {
  location = coalesce(
    var.region,
    "US",
  )

}


resource "aws_storage_bucket" "_" {
  name          = var.name
  location      = local.location
  force_destroy = true
}

resource "aws_s3_bucket" "example" {
  bucket = var.name

  tags = {
    Name        = "Hubctl bucket"
    Environment = "Dev"
  }
}


