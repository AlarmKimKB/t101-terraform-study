data "aws_kms_secrets" "scott_rds_creds" {
  secret {
    name    = "secrets"
    payload = file("${path.module}/13_db_creds.yml.encrypted")
  }
}

locals {
  db_creds = yamldecode(data.aws_kms_secrets.scott_rds_creds.plaintext["secrets"])
}