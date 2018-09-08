variable "aws_region" {}

variable "mail_target" {}

variable "mail_user" {}

variable "mail_from" {}

variable "mail_name" {}

variable "mail_subject" {}

variable "mail_password" {}

variable "mail_api_url" {}

variable "mail_api_host" {}

variable "aws_account_id" {}

variable "config_file" {}

variable "site_domain" {}

output "api_prod_url" {
    value = "https://${aws_api_gateway_deployment.website_email_api_prod.rest_api_id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_deployment.website_email_api_prod.stage_name}"
}

output "api_root_id" {
     value = "${aws_api_gateway_rest_api.website_api.root_resource_id}"
}
 
output "api_id" {
     value = "${aws_api_gateway_rest_api.website_api.id}"
}
