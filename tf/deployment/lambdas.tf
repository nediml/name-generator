resource "aws_lambda_function" "after_allow_test_traffic" {
  function_name = "${var.namespace}-${var.env}-${var.module_name}-after-allow-test-traffic"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 900
  filename      = "./deployment/lambda-package-placeholder.zip"
  memory_size   = 1024

  tags = var.common_tags

  lifecycle {
    ignore_changes = [
      filename,
    ]
  }
}

resource "aws_lambda_permission" "after_allow_test_traffic" {
  statement_id  = "${var.namespace}-${var.env}-${var.module_name}-after-allow-test-traffic"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.after_allow_test_traffic.arn
  principal     = "codedeploy.amazonaws.com"
  source_arn    = aws_codedeploy_deployment_group.service.service_role_arn
}

#---

resource "aws_lambda_function" "after_allow_traffic" {
  function_name = "${var.namespace}-${var.env}-${var.module_name}-after-allow-traffic"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 900
  filename      = "./deployment/lambda-package-placeholder.zip"
  memory_size   = 1024

  tags = var.common_tags

  lifecycle {
    ignore_changes = [
      filename,
    ]
  }
}

resource "aws_lambda_permission" "after_allow_traffic" {
  statement_id  = "${var.namespace}-${var.env}-${var.module_name}-after-allow-traffic"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.after_allow_test_traffic.arn
  principal     = "codedeploy.amazonaws.com"
  source_arn    = aws_codedeploy_deployment_group.service.service_role_arn
}