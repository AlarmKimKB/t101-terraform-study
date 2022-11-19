provider "aws" {
    region = "ap-northeast-2"
}

terraform {
  backend "s3" {
    bucket = "scott-t101study-tfstate-files"
    key    = "stage/mysql/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "terraform-locks-week3-files"
  }
}

module "mysql" {
    source = "../../02_module/01_mysql/"

    db_username  = "terraform"
    db_password  = "terraform!!"

    env          = "stg"
    vpc_cidr     = "10.10.0.0/16"
    subnet3_cidr = "10.10.3.0/24"
    subnet4_cidr = "10.10.4.0/24"
}
