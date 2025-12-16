output "website_url" {
  description = "URL of the static website"
  value       = aws_s3_bucket_website_configuration.website_config.website_endpoint
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.website_bucket.bucket
}

output "bucket_regional_domain_name" {
  description = "Regional domain name of the bucket"
  value       = aws_s3_bucket.website_bucket.bucket_regional_domain_name
}