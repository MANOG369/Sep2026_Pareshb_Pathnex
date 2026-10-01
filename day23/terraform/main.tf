resource "aws_api_gateway_rest_api" "pathnex_api" {
  name        = "pathnex-api"
  description = "Pathnex API"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "pathnex-lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_api_gateway_resource" "pathnex_resource" {
  rest_api_id = aws_api_gateway_rest_api.pathnex_api.id
  parent_id   = aws_api_gateway_rest_api.pathnex_api.root_resource_id
  path_part   = "pathnex"
}

resource "aws_api_gateway_method" "pathnex_method" {
  rest_api_id   = aws_api_gateway_rest_api.pathnex_api.id
  resource_id   = aws_api_gateway_resource.pathnex_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_lambda_function" "pathnex_lambda" {
  function_name = "pathnex-lambda"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  filename      = "lambda.zip"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.pathnex_api.id
  resource_id             = aws_api_gateway_resource.pathnex_resource.id
  http_method             = aws_api_gateway_method.pathnex_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.pathnex_lambda.invoke_arn
}
