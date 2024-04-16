resource "aws_s3_bucket" "main_s3_bucket" {
  bucket = var.bucket_name

  tags = {
    Environment = var.env
  }
}

resource "aws_s3_bucket_ownership_controls" "owner" {
  bucket = aws_s3_bucket.main_s3_bucket.id
  rule {
  object_ownership = "BucketOwnerPreferred"
  }
}


# make S3 access public so that anyone can access it
resource "aws_s3_bucket_public_access_block" "mypublicaccess" {
  bucket = aws_s3_bucket.main_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# index.html
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.main_s3_bucket.id
  key    = "index.html"
  source = "/home/harisheoran/projects/AWS-Cloud-Resume/website/index.html"
  content_type = "text/html"
}

# css
resource "aws_s3_object" "css" {
  bucket = aws_s3_bucket.main_s3_bucket.id
  key    = "risen.css"
  source = "/home/harisheoran/projects/AWS-Cloud-Resume/website/risen.css"
  content_type = "css"
}

# image
resource "aws_s3_object" "image" {
  bucket = aws_s3_bucket.main_s3_bucket.id
  key    = "profile.png"
  source = "/home/harisheoran/projects/AWS-Cloud-Resume/website/profile.png"
  content_type = "png"
}

# configure the html files for website
resource "aws_s3_bucket_website_configuration" "main_website" {
  bucket = aws_s3_bucket.main_s3_bucket.id

  index_document {
    suffix = "index.html"
  }
}

/*
resource "aws_s3_bucket_policy" "public_access_read" {
  bucket = aws_s3_bucket.main_s3_bucket.id
  policy = data.aws_iam_policy_document.public_access_read.json
  depends_on = [
  aws_s3_bucket_public_access_block.mypublicaccess
  ]
}

data "aws_iam_policy_document" "public_access_read" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.main_s3_bucket.arn,
      "${aws_s3_bucket.main_s3_bucket.arn}/*",
    ]
  }
}*/
