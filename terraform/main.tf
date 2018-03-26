provider "aws" {
  region  = "us-east-1"
  profile = "tfbuild"
}

variable iam_account {}

resource "aws_s3_bucket" "lambda-file" {
  bucket        = "giancarlopetrini-lambda-file"
  force_destroy = true

  tags {
    Name = "giancarlopetrini-lambda-file"
  }
}
