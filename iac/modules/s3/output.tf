output "origin_domain" {
  value = aws_s3_bucket.main_s3_bucket.bucket_regional_domain_name
}

output "bucket_arn" {
  value = aws_s3_bucket.main_s3_bucket.arn
}

output "bucket_id" {
  value = aws_s3_bucket.main_s3_bucket.id
}