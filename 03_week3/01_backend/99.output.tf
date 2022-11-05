output "s3_bucket_arn" {
  description = "S3 Bucket arn"
  value       = aws_s3_bucket.backend.arn
}

output "s3_bucket_name" {
  description = "S3 Bucket Name"
  value       = aws_s3_bucket.backend.bucket
}

output "dynamodb_table_name" {
  description = "DynamoDB Table Name"
  value       = aws_dynamodb_table.dynamodb_table.name
}