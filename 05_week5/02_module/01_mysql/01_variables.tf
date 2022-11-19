###########################################
####          Common Variables         ####
###########################################

variable "env" {
  description = "Environment"
  type        = string
}


###########################################
####          VPC Variables            ####
###########################################

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "subnet_rds_cidr" {
  description = "RDS Subnet Cidr & AZ"
  type        = list
}

variable "subnet_rds_az" {
  description = "RDS Subnet Cidr & AZ"
  type        = list
}


###########################################
####           DB Variables            ####
###########################################

variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The name to use for the database"
  type        = string
}

variable "db_engine" {
  description = "DB Engine"
  type        = string
}

variable "db_storage" {
  description = "DB Storage"
  type        = number
}

variable "db_instance_type" {
  description = "DB Instance Type"
  type        = string
}



