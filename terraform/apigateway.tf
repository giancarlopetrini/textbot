resource "aws_api_gateway_rest_api" "lex-gateway-api" {
  name        = "lex-gateway-api"
  description = "processing twilio --- lambda connection"
}

resource "aws_api_gateway_resource" "lex-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.lex-gateway-api.id}"
  parent_id   = "${aws_api_gateway_rest_api.lex-gateway-api.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "lex-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.lex-gateway-api.id}"
  resource_id   = "${aws_api_gateway_resource.lex-resource.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lex-integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.lex-gateway-api.id}"
  resource_id             = "${aws_api_gateway_method.lex-method.id}"
  http_method             = "${aws_api_gateway_method.lex-method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.lex-lambda.invoke_arn}"

  # request passthrough templating/format...
}

resource "aws_api_gateway_deployment" "lex-gateway" {
  depends_on = [
    "aws_api_gateway_integration.lex-integration",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.lex-gateway-api.id}"
  stage_name  = "dev"
}
