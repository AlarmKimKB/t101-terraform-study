
variable "study_name" {
  description = "스터디 내용"
  default     = "terraform"
}

variable "env" {
  description = "VPC 환경 (ex. dev , stg , prd , qa)"
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR Block. (ex. 10.10.0.0/16)"
  type        = string
  default     = "10.10.0.0/16"
}

variable "pub_sub_cidr" {
  description = "Public CIDR Block.  ex. [{az = 'ap-northeast-2a' , cidr = '10.0.10.0/24'}]"
  type        = list(object({
                  // Subnet 가용 영역
                  az    =   string
                  // Subnet CIDR
                  cidr  =   string
                }))
  default     = [
    {az = "ap-northeast-2a", cidr = "10.10.1.0/24"},
    {az = "ap-northeast-2c", cidr = "10.10.2.0/24"}
  ]
}

variable "pri_sub_cidr" {
  description = "Private CIDR Block.  ex. [{az = 'ap-northeast-2a' , cidr = '10.0.10.0/24' , use_nat = true}]"
  type        = list(object({
                  // Subnet 가용 영역
                  az      =   string
                  // Subnet CIDR
                  cidr    =   string
                  // Nat G/W 필요 유무 ('true' : 필요)
                  use_nat =   bool
                }))
  default     = [
    {az = "ap-northeast-2a", cidr = "10.10.3.0/24", use_nat = true},
    {az = "ap-northeast-2c", cidr = "10.10.4.0/24", use_nat = true}
  ]
}