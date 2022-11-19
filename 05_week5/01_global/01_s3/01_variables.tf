variable "create_s3" {
    description = "S3 Bucket Option | Create = true"
    type        = bool
    default     = true
}

variable "s3_bucket" {
    description = "Use Origin S3 Bucket"
    type        = string
    default     = null
}