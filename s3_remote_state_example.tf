/*
In order to first create the s3 bucket for the remote state, we have to first provision this s3
bucking into AWS by run `terraform apply` from our local state, then uncomment the terraform backend
section and then rerun `terraform apply` so the state can find such bucket in AWS S3 service.

To successfully destroy this infrastructure, we have to follow a two-step process.
1. We have to delete/comment the terraform backend section.
2. Run `terraform init` again to recreate the local state.
3. Then run `terraform destroy`
*/
terraform {
  backend "s3" {
    bucket = aws_s3_bucket.terraform_state_example.bucket
    key = "global/s3/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = aws_dynamodb_table.terraform_locks.name
    encrypt = true
  }
}

resource "aws_s3_bucket" "terraform_state_example" {
  bucket = "terraform_state_julio"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state_example.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state_example.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

// As a locking mechanism to allow only 1 user to write to state
resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform_state_locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}