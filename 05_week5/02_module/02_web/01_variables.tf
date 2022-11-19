###########################################
####          Common Variables         ####
###########################################

variable "env" {
  description = "Environment"
  type        = string
}


###########################################
####         Backend Variables         ####
###########################################

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


###########################################
####           VPC Variables           ####
###########################################

variable "subnet_web_cidr" {
  description = "Web Sunet CIDR Block"
  type        = list
}

variable "subnet_web_az" {
  description = "Web Sunet AZ"
  type        = list
}


###########################################
####           EC2 Variables           ####
###########################################

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

