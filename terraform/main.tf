provider "aws" {
  region  = "us-east-1"
  profile = "tfbuild"
}

resource "aws_s3_bucket" "terraform-state" {
  bucket        = "terraform-state-s3-giancarlopetrini"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags {
    Name = "terraform-state-s3-giancarlopetrini"
  }
}

variable iam_account {}

resource "aws_s3_bucket_policy" "terraform-state-policy" {
  bucket = "${aws_s3_bucket.terraform-state.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [{
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.iam_account}:user/tfbuild"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::terraform-state-s3-giancarlopetrini"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.iam_account}:user/tfbuild"
            },
            "Action": ["s3:GetObject", "s3:PutObject"],
            "Resource": "arn:aws:s3:::terraform-state-s3-giancarlopetrini/terraform.tfstate"
        }
    ]
}
POLICY
}

resource "aws_dynamodb_table" "dynamodb-terraform-state" {
  name           = "dynamodb-terraform-state-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "dynamodb-terraform-state-lock"
  }
}

resource "aws_s3_bucket" "lambda-file" {
  bucket        = "giancarlopetrini-lambda-file"
  force_destroy = true

  tags {
    Name = "giancarlopetrini-lambda-file"
  }
}
