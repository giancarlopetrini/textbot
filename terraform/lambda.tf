resource "aws_iam_role" "lex-lambda-role" {
  name = "lex-lambda-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

variable "twilio_sid" {}
variable "twilio_auth" {}
variable "twilio_num" {}

resource "aws_lambda_function" "lex-lambda" {
  function_name = "lex-handler"
  s3_bucket     = "${aws_s3_bucket.lambda-file.bucket}"
  s3_key        = "lambda.zip"
  handler       = "lambda"
  runtime       = "go1.x"
  role          = "${aws_iam_role.lex-lambda-role.arn}"

  environment {
    variables {
      twilio_sid  = "${var.twilio_sid}"
      twilio_auth = "${var.twilio_auth}"
      twilio_num  = "${var.twilio_num}"
    }
  }
}
