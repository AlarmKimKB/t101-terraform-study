terraform {
  backend "s3" {
    bucket = "scott-t101study-tfstate"
    key    = "dev/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "scott-terraform-locks"
    # encrypt        = true
  }
}