provider "aws" {
  region  = "ap-northeast-2"
}

terraform {
  backend "s3" {
    bucket = "scott-t101study-tfstate-files"
    key    = "stage/web/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "terraform-locks-week3-files"
  }
}

module "web" {
    source = "../../02_module/02_web/"

    // common var
    env                 = "stg"

    // backend var
    s3_vpc_location     = "scott-t101study-tfstate-files"
    s3_vpc_key          = "stage/mysql/terraform.tfstate"
    s3_vpc_region       = "ap-northeast-2"

    // vpc var
    subnet_web_cidr     = ["10.10.1.0/24", "10.10.2.0/24"]
    subnet_web_az       = ["ap-northeast-2a", "ap-northeast-2c"]

    // ec2 var
    ec2_type            = "t2.micro"
    asg_max_ec2         = 5
    asg_min_ec2         = 2
}
