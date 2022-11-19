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
  default     = "terraformdb"
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "subnet3_cidr" {
  description = "Subnet3 CIDR Block"
  type        = string
}

variable "subnet4_cidr" {
  description = "Subnet4 CIDR Block"
  type        = string
}

