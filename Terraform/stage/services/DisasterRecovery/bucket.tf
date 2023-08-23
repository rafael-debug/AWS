resource "aws_s3_bucket" "page_dr" {
  bucket = "staticwebpage2-disasterrecovery"
  tags   = local.common_tags

}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.page_dr.id
  acl    = "private"
}

resource "aws_s3_bucket_object" "pagineta" {
  bucket = aws_s3_bucket.page_dr.bucket
  key    = local.object_filepath
  source = local.object_filepath
  tags   = local.common_tags
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "name" {
  bucket = aws_s3_bucket.page_dr.bucket
  index_document {
    suffix = "index.html"

  }

}