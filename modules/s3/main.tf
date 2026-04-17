resource "aws_s3_bucket" "my_bucket" {
    bucket = "terraform-bucket-aws-ap-south-1"
}
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}