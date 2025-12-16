variable "bucket_name" {
  description = "Name of the S3 bucket for static website"
  type        = string
  default     = "my-terraform-website-bucket-2024" # Make this unique
}

variable "website_files" {
  description = "Path to website files"
  type        = string
  default     = "./website" # Folder containing your website files
}