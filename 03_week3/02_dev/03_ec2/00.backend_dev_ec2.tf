provider "aws" {
  region  = "ap-northeast-2"
}

terraform {
  backend "s3" {
    bucket = "s3-terraform-state-week3"
    key    = "dev/ec2/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "dynamo-state-week3-lock"
  }
}

data "terraform_remote_state" "dev_vpc" {
  backend = "s3"
  config = {
    bucket = "s3-terraform-state-week3"
    key    = "dev/vpc/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

data "terraform_remote_state" "dev_rds" {
  backend = "s3"
  config = {
    bucket = "s3-terraform-state-week3"
    key    = "dev/rds/terraform.tfstate"
    region = "ap-northeast-2"
  }
}