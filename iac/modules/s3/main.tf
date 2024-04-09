resource "aws_s3_bucket" "main_s3_bucket" {
  bucket = var.bucket_name

  tags = {
    Environment = "prod"
  }
}


# bucket ownership
resource "aws_s3_bucket_ownership_controls" "myownershipcontrols" {
  bucket = aws_s3_bucket.main_s3_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# make S3 access public so that anyone can access it
resource "aws_s3_bucket_public_access_block" "mypublicaccess" {
  bucket = aws_s3_bucket.main_s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# access control list
resource "aws_s3_bucket_acl" "myacl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.myownershipcontrols,
    aws_s3_bucket_public_access_block.mypublicaccess,
  ]

  bucket = aws_s3_bucket.main_s3_bucket.id
  acl    = "public-read"
}

# index.html
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.main_s3_bucket.id
  key    = "index.html"
  source = "/home/harisheoran/projects/AWS-Cloud-Resume/website/index.html"
  acl = "public-read"
  content_type = "text/html"
}

# css
resource "aws_s3_object" "css" {
  bucket = aws_s3_bucket.main_s3_bucket.id
  key    = "risen.css"
  source = "/home/harisheoran/projects/AWS-Cloud-Resume/website/risen.css"
  acl = "public-read"
  content_type = "css"
}

# image
resource "aws_s3_object" "image" {
  bucket = aws_s3_bucket.main_s3_bucket.id
  key    = "profile.png"
  source = "/home/harisheoran/projects/AWS-Cloud-Resume/website/profile.png"
  acl = "public-read"
  content_type = "png"
}

# configure the html files for website
resource "aws_s3_bucket_website_configuration" "main_website" {
  bucket = aws_s3_bucket.main_s3_bucket.id

  index_document {
    suffix = "index.html"
  }

  depends_on = [ aws_s3_bucket_acl.myacl ]
}

