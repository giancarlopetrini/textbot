resource "aws_api_gateway_rest_api" "textbot-apigw" {
  name        = "textbot-apigw"
  description = "processing twilio and lambda connection"
}

resource "aws_api_gateway_method" "textbot-apigw-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.textbot-apigw.id}"
  resource_id   = "${aws_api_gateway_rest_api.textbot-apigw.root_resource_id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "textbot-apigw-integration" {
  depends_on = [
    "aws_api_gateway_rest_api.textbot-apigw",
  ]

  rest_api_id             = "${aws_api_gateway_rest_api.textbot-apigw.id}"
  resource_id             = "${aws_api_gateway_rest_api.textbot-apigw.root_resource_id}"
  http_method             = "${aws_api_gateway_method.textbot-apigw-method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "${aws_lambda_function.textbot-handler.invoke_arn}"

  request_templates = {
    "application/x-www-form-urlencoded" = <<XML_TEMPLATE
{
#set($allParams = $input.params())
{
"body-json" : $input.json('$'),
"params" : {
#foreach($type in $allParams.keySet())
    #set($params = $allParams.get($type))
"$type" : {
    #foreach($paramName in $params.keySet())
    "$paramName" : "$util.escapeJavaScript($params.get($paramName))"
        #if($foreach.hasNext),#end
    #end
}
    #if($foreach.hasNext),#end
#end
},
"stage-variables" : {
#foreach($key in $stageVariables.keySet())
"$key" : "$util.escapeJavaScript($stageVariables.get($key))"
    #if($foreach.hasNext),#end
#end
},
"context" : {
    "account-id" : "$context.identity.accountId",
    "api-id" : "$context.apiId",
    "api-key" : "$context.identity.apiKey",
    "authorizer-principal-id" : "$context.authorizer.principalId",
    "caller" : "$context.identity.caller",
    "cognito-authentication-provider" : "$context.identity.cognitoAuthenticationProvider",
    "cognito-authentication-type" : "$context.identity.cognitoAuthenticationType",
    "cognito-identity-id" : "$context.identity.cognitoIdentityId",
    "cognito-identity-pool-id" : "$context.identity.cognitoIdentityPoolId",
    "http-method" : "$context.httpMethod",
    "stage" : "$context.stage",
    "source-ip" : "$context.identity.sourceIp",
    "user" : "$context.identity.user",
    "user-agent" : "$context.identity.userAgent",
    "user-arn" : "$context.identity.userArn",
    "request-id" : "$context.requestId",
    "resource-id" : "$context.resourceId",
    "resource-path" : "$context.resourcePath"
    }
}

  }
  XML_TEMPLATE
  }

  passthrough_behavior = "WHEN_NO_TEMPLATES"
}

resource "aws_api_gateway_deployment" "textbot-apigw-deploy" {
  depends_on = [
    "aws_api_gateway_integration.textbot-apigw-integration",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.textbot-apigw.id}"
  stage_name  = "dev"
}

output "api_invoke_url" {
  value = "${aws_api_gateway_deployment.textbot-apigw-deploy.invoke_url}"
}
