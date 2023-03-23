resource "aws_apigatewayv2_api" "api" {
  name          = "productreview"
  protocol_type = "HTTP"
  body          = file("./APIGatewayProductAPI.json")
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id = aws_apigatewayv2_api.api.id
  name   = "oregon"
}

resource "aws_apigatewayv2_deployment" "deploy" {
  api_id = aws_apigatewayv2_api.api.id
}