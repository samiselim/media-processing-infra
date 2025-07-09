output "media_uploads_bucket" {
  value = aws_s3_bucket.media_uploads.bucket
}

output "processed_media_bucket" {
  value = aws_s3_bucket.processed_media.bucket
}
