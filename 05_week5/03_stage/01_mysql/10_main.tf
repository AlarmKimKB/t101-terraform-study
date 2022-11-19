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
    source           = "../../02_module/01_mysql/"

    // common var
    env              = "stg"

    // vpc var
    vpc_cidr         = "10.10.0.0/16"
    subnet_rds_cidr  = ["10.10.3.0/24", "10.10.4.0/24"]
    subnet_rds_az    = ["ap-northeast-2a", "ap-northeast-2c"]

    // db var
    db_username      = "terraform"
    db_password      = "terraform!!"
    db_name          = "terraformdb"
    db_engine        = "mysql"
    db_instance_type = "db.t2.micro"
    db_storage       = 10
}
