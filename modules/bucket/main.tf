terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0"
    }
  }
}

# ---------------------------------------
# BUCKET CREATION
# ---------------------------------------
resource "aws_s3_bucket" "general_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.env[0]
    Project     = var.project_name
  }
}

resource "aws_s3_bucket_versioning" "name" {
  bucket = aws_s3_bucket.general_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}