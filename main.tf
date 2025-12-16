# Create S3 bucket for static website
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  
  tags = {
    Name        = "Static Website Bucket"
    Environment = "Dev"
  }
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Set bucket policy to allow public read access
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}

# Disable block public access (required for public website)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Upload website files
resource "aws_s3_object" "website_files" {
  for_each = fileset(var.website_files, "**/*")

  bucket       = aws_s3_bucket.website_bucket.id
  key          = each.value
  source       = "${var.website_files}/${each.value}"
  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg",
    "gif"  = "image/gif",
    "svg"  = "image/svg+xml",
    "ico"  = "image/x-icon",
    "json" = "application/json",
    "txt"  = "text/plain"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "binary/octet-stream")
  
  etag = filemd5("${var.website_files}/${each.value}")
}