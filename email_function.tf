data "external" "pip_install" {
    program = ["bash", "${path.module}/email/pip_install.sh"]
}

data "archive_file" "lambda" {
    type = "zip"
    source_dir = "${path.module}/email"
    output_path = "${path.module}/lambda.zip"    
}

resource "aws_iam_role" "lambda_email_role" {
    name = "lambda_email_role"
    assume_role_policy = "${file("${path.module}/lambda_email_role.json")}"
}

resource "aws_lambda_function" "lambda_email_function" {
    filename = "${data.archive_file.lambda.output_path}"
    function_name = "email_function"
    role = "${aws_iam_role.lambda_email_role.arn}"
    handler = "contact_email.lambda_handler"
    runtime = "python2.7"
    timeout = "10"
    source_code_hash = "${base64sha256(file("${data.archive_file.lambda.output_path}"))}"
    publish = true

    environment = {
        variables = {
            "MAIL_API_HOST" = "${var.mail_api_host}",
            "MAIL_API_URL" = "${var.mail_api_url}",
            "MAIL_USER" = "${var.mail_user}",
            "MAIL_FROM" = "${var.mail_from}",
            "MAIL_NAME" = "${var.mail_name}",
            "MAIL_SUBJECT" = "${var.mail_subject}",
            "MAIL_PASS" = "${var.mail_password}",
            "MAIL_TARGET" = "${var.mail_target}"
        }
    }
}

resource "aws_lambda_permission" "allow_api_gateway" {
    function_name = "${aws_lambda_function.lambda_email_function.function_name}"
    statement_id = "AllowExecutionFromApiGateway"
    action = "lambda:InvokeFunction"
    principal = "apigateway.amazonaws.com"
    source_arn = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.website_api.id}/*/${aws_api_gateway_integration.website_api_email_method_integration.integration_http_method}${aws_api_gateway_resource.website_api_email_resource.path}"
}
