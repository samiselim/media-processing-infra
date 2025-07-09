resource "aws_s3_bucket" "media_uploads" {
  bucket = "${var.project}-media-uploads"
  force_destroy = true
}

resource "aws_s3_bucket" "processed_media" {
  bucket = "${var.project}-processed-media"
  force_destroy = true
}
