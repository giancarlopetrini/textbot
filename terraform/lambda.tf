resource "aws_iam_role" "lambda-role-textbot-handler" {
  name = "lambda-role-textbot-handler"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "lambda-role-for-lex_lambda-lex-policy" {
  name = "lambda-lex-policy"
  role = "${aws_iam_role.lambda-role-textbot-handler.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "lex:PostText"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY
}

variable "twilio_sid" {}
variable "twilio_auth" {}
variable "twilio_num" {}

resource "aws_lambda_function" "textbot-handler" {
  function_name = "lex-handler"
  s3_bucket     = "${aws_s3_bucket.lambda-file.bucket}"
  s3_key        = "lambda.zip"
  handler       = "lambda"
  runtime       = "go1.x"
  role          = "${aws_iam_role.lambda-role-textbot-handler.arn}"

  environment {
    variables {
      twilio_sid  = "${var.twilio_sid}"
      twilio_auth = "${var.twilio_auth}"
      twilio_num  = "${var.twilio_num}"
    }
  }
}
