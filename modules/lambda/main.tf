data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/lambda_function.zip"
}

locals {
  env_variables = {
    for key, value in var.env_map : key => value
  }
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = var.role
  handler       = var.handler
  runtime       = var.runtime
  filename      = data.archive_file.lambda_zip.output_path

  environment {
    variables = local.env_variables
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/lambda_function.zip"
}

locals {
  env_variables = {
    for key, value in var.env_map : key => value
  }
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = var.role
  handler       = var.handler
  runtime       = var.runtime
  filename      = data.archive_file.lambda_zip.output_path

  environment {
    variables = local.env_variables
  }
}

resource "aws_lambda_function_url" "this" {
  count = var.create_function_url ? 1 : 0

  authorization_type = "NONE"
  function_name      = aws_lambda_function.this.function_name

  cors {
    allow_origins  = ["*"]
    allow_methods  = ["*"]
    allow_headers  = ["*"]
    expose_headers = ["*"]
    max_age        = 86400
  }
}
