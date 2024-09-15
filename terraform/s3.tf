resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket.name

  tags = {
    Name        = var.s3_bucket.name
    # Environment = "Dev"
  }
}

# S3 버킷 퍼블릭 액세스 차단 구성을 관리함
resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}