resource "aws_api_gateway_rest_api" "website_api" {
     name = "website_api"
     description = "API for static website functions"
}

resource "aws_api_gateway_resource" "website_api_email_resource" {
    path_part = "messages"
    parent_id = "${aws_api_gateway_rest_api.website_api.root_resource_id}"
    rest_api_id = "${aws_api_gateway_rest_api.website_api.id}"
}

resource "aws_api_gateway_method" "website_api_email_method" {
    rest_api_id   = "${aws_api_gateway_rest_api.website_api.id}"
    resource_id   = "${aws_api_gateway_resource.website_api_email_resource.id}"
    http_method   = "POST"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "website_api_email_method_integration" {
    rest_api_id   = "${aws_api_gateway_rest_api.website_api.id}"
    resource_id   = "${aws_api_gateway_resource.website_api_email_resource.id}"
    http_method = "${aws_api_gateway_method.website_api_email_method.http_method}"
    type = "AWS_PROXY"
    integration_http_method = "POST"
    uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda_email_function.arn}/invocations"
}

resource "aws_api_gateway_method_response" "website_api_email_response_method" {
    rest_api_id = "${aws_api_gateway_rest_api.website_api.id}"
    resource_id = "${aws_api_gateway_resource.website_api_email_resource.id}"
    http_method = "${aws_api_gateway_integration.website_api_email_method_integration.http_method}"
    status_code = "200"
    response_models = { "application/json" = "Empty" }
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin" = true
    }
}

resource "aws_api_gateway_integration_response" "website_api_email_method_integration" {
    rest_api_id = "${aws_api_gateway_rest_api.website_api.id}"
    resource_id = "${aws_api_gateway_resource.website_api_email_resource.id}"
    http_method = "${aws_api_gateway_method_response.website_api_email_response_method.http_method}"
    status_code = "200"
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS,GET,PUT,PATCH,DELETE'",
        "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
}

resource "aws_api_gateway_deployment" "website_email_api_prod" {
    depends_on = [
        "aws_api_gateway_method.website_api_email_method",
        "aws_api_gateway_integration.website_api_email_method_integration"
    ]
    rest_api_id = "${aws_api_gateway_rest_api.website_api.id}"
    stage_name = "api"
    
    provisioner "local-exec" {
        command = "export EMAIL_CONFIG_FILE_VAR=${var.config_file}; if [! -z "$EMAIL_CONFIG_FILE_VAR" ]; then python ${path.module}/utils/update_config.py --api_url https://${aws_api_gateway_deployment.website_email_api_prod.rest_api_id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_deployment.website_email_api_prod.stage_name} ${var.config_file}; fi"
        on_failure = "continue"
    }
}