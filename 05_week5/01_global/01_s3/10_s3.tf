provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "scott_s3" {
  // use 'conditionals'
  count  = var.create_s3 ? 1 : 0
  bucket = "scott-t101study-tfstate-files"
}

data "aws_s3_bucket" "scott_s3_selected" {
  depends_on = [aws_s3_bucket.scott_s3]

  // use 'conditionals'
  bucket     = var.create_s3 ? aws_s3_bucket.scott_s3[0].bucket : var.s3_bucket
}

resource "aws_s3_bucket_versioning" "scott_s3_versioning" {
  bucket = data.aws_s3_bucket.scott_s3_selected.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "scott_dynamodb_table" {
  name         = "terraform-locks-week3-files"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
