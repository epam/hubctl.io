variable "name" {
  type = string
}

variable "service_account_name" {
  type    = string
  default = ""
}

variable "acl" {
  type = string
  description = "S3 bucket ACL"
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.name
  acl    = var.acl

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  versioning = {
    enabled = true
  }

  tags = {
    Name        = "Hubctl bucket"
    Environment = "Dev"
  }
}
