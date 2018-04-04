provider "aws" {
  region  = "us-east-1"
  profile = "tfbuild"
}

variable "s3_bucket_name" {}

resource "aws_s3_bucket" "lambda-file" {
  bucket        = "${var.s3_bucket_name}"
  force_destroy = true

  tags {
    Name = "${var.s3_bucket_name}"
  }
}
