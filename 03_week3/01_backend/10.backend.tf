provider "aws" {
  region  = "ap-northeast-2"
}

resource "aws_s3_bucket" "backend" {
  bucket = "s3-terraform-state-week3"

  lifecycle {
    prevent_destroy = false
  }
  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name         = "dynamo-state-week3-lock"

  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}