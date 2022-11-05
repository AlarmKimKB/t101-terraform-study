provider "aws" {
  region  = "ap-northeast-2"
}

terraform {
  backend "s3" {
    bucket = "s3-terraform-state-week3"
    key    = "dev/vpc/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "dynamo-state-week3-lock"
  }
}