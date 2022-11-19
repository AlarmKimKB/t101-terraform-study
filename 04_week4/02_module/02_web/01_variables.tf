variable "s3_vpc_location" {
    description = "S3 Backend Location"
    type        = string 
}

variable "s3_vpc_key" {
    description = "S3 Backend Key"
    type        = string  
}

variable "s3_vpc_region" {
    description = "S3 Backend Region"
    type        = string
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "subnet1_cidr" {
  description = "Subnet3 CIDR Block"
  type        = string
}

variable "subnet2_cidr" {
  description = "Subnet4 CIDR Block"
  type        = string
}

variable "ec2_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "asg_max_ec2" {
  type = number
}

variable "asg_min_ec2" {
  type = number
}

