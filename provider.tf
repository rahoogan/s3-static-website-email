provider "aws" {
    version = "~> 1.3"	
    region = "${var.aws_region}"
}

provider "archive" {
    version = "~> 1.0"
}

provider "external" {
    version = "~> 1.0"
}
