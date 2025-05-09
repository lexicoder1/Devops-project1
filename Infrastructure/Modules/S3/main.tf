resource "aws_s3_bucket" "examplebucket"{
    bucket = var.bucket_name   # this name is unique

    # lifecycle {
    #   prevent_destroy =true
    # }
   
   tags = {
    Name        = var.bucket_name
    Environment = var.Env
  }

}

resource "aws_s3_bucket_versioning" "examplebucket" {
  bucket = aws_s3_bucket.examplebucket.id
  versioning_configuration {
    status = var.enable_bucket_versioning
  }
}    

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.examplebucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_object" "example" {
  for_each               = var.upload_files ? { for idx, file in var.files : idx => file }  : {}
  key                    = each.value.key
  bucket                 = aws_s3_bucket.examplebucket.id
  source                 = each.value.source
  server_side_encryption = "AES256"

}