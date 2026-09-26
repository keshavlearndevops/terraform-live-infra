provider "aws" {
  region = "us-east-1"
}
# remote backend for state file
# natively state locking use_lockfile
terraform {
  backend "s3" {
    bucket       = "terraform-backend-1021-kez"
    key          = "global/s3/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-backend-1021-kez"
  # prevent accidental deletion
  #   lifecycle {
  #     prevent_destroy = true
  #   }
}
# enable versoning so you can see the full revisions history of your state
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.bucket
  versioning_configuration {
    status = "Enabled"
  }
}
# enable server side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
# Explicitly block public access
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

