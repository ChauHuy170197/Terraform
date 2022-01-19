terraform {
 backend "s3" {
    bucket         = "huy-abc-s3-xyz-bucket"
    key            = "state/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    kms_key_id     = "alias/terraform-bucket-key"
    dynamodb_table = "state"
 }
}
provider "aws" {
  region = "us-east-2"
}
resource "aws_s3_bucket" "state" {
  bucket = "huy-abc-s3-xyz-bucket"
  acl    = "private"
  tags = {
     Name        = "My bucket"
     Environment = "Dev"
   }
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.terraform-bucket-key.arn
        sse_algorithm     = "aws:kms"
     }
   }
 }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_dynamodb_table" "state" {
  name           = "state"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
 }
}
 
