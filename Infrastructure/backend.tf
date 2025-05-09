# # for state s3
# resource "aws_s3_bucket" "terraform_state"{
#     bucket = "ifeany-s3-state3"    # this name is unique

#     # lifecycle {
#     #   prevent_destroy =true
#     # }
   
#    tags = {
#     Name        = "My bucket"
#     Environment = "Dev"
#   }

# }

# resource "aws_s3_bucket_versioning" "versioning_example" {
#   bucket = aws_s3_bucket.terraform_state.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
#   bucket = aws_s3_bucket.terraform_state.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm     = "AES256"
#     }
#   }
# }

# # for state dynamodb
# resource "aws_dynamodb_table" "example" {
#   name             = "s3-state-lock"
#   billing_mode     = "PAY_PER_REQUEST"
#   hash_key         = "LockID"
  
#   attribute {
#     name = "LockID"
#     type = "S"
#   }

  
# }

