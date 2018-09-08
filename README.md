# AWS S3 Static Website Email Module

## Description
This simple terraform module aims to bootstrap an existing static website (hosted anywhere).

It sets up a lambda function and API which can be called from a static website to send emails using an external email provider's REST API (for example Mailgun). This is intended to provide additional functionality for small static websites, where they may need to provide email notifications for users or admins triggered by actions on the website - such as submitting forms.

An alternative to this is to use Amazon's SNS (Simple Notification Service). However some email providers offer free emails under a certain limit which may be attractive to those keen on saving money. This module allows you to leverage these providers' API's. 

## Variables

The following variables are required to be setup (either in a terraform file or as environment variables), when using the module:

| Variable Name | Description                                                   |  
|---------------|---------------------------------------------------------------|
| aws_region    | The AWS region to deploy the lambda function and API Gateway  |
| mail_target   | The email address to forward notifications to (i.e destination email address) |
| mail_user     | The username (if any) used to authenticate to the external email provider (for eg. Mailgun) |
| mail_from     | The source email address to be used in the email              |
| mail_name     | The name associated with the source email address to be used in the email |
| mail_subject  | The subject to be used in the email                           |
| mail_password | The password (if any) used to authenticate to the external email provider (for eg. Mailgun) |
| mail_api_url  | The REST API URL of the external email provider to used to send emails |
| mail_api_host | The hostname of the external email provider to used to send emails |
| aws_account_id| The account ID used to authenticate to AWS |
| config_file   | (Optional: Set to empty if unused) Specifies the config file (yml) of the static website generator (for example Jekyll or Hugo) used to create the website the function will bootstrap. If set, the config will be updated with the latest API URL endpoint of the generated function. This can then be used automatically by the site generator |   
| site_domain   | The domain name of the static website this function will bootstrap |

## Output Variables

The following variables will be output when the module is run:

| Output Variable Name | Description | Role |
| ---------------------|-------------|------|
| api_id               | The ID of the generated REST API (API Gateway) | Used for management |
| api_root_id          | The resource ID of the generated REST API's root (API Gateway) | Used for management |
| api_prod_url         | The URL of the prod API's endpoint - used by the static website to send requests to | Primary output |

## Example 
A simple example of how to use the module in a `main.tf` file is shown below. This example uses the Send API Provided by Mailjet. **Note**: All variable values have been contrived and are not real.

```
module "static-website-email" {
    source = "github.com/rahoogan/s3-static-website-email"
    aws_account_id = "760938983754"
    aws_region = "ap-southeast-2"
    site_domain = "example.com.au"
    mail_target = "notification@example.com.au"
    mail_user = "21615436124765498235330468567678"
    mail_password = "91873981749875928733502384985332"
    mail_api_url = "/v3/send"
    mail_api_host = "api.mailjet.com"
    config_file = "/home/rahoogan/examplewebsite/_config.yml"
}

output "api_id" {
    value = "${module.static-website-email.api_id}"
}
output "api_root_id" {
    value = "${module.static-website-email.api_root_id}"
}
output "api_prod_url" {
    value = "${module.static-website-email.api_prod_url}"
}
```