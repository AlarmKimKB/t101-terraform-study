output "s3_bucket_arn" {
  value       = data.aws_s3_bucket.scott_s3_selected.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.scott_dynamodb_table.name
  description = "The name of the DynamoDB table"
}
