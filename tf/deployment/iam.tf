data "aws_iam_policy" "code_deploy_service_role_policy" {
  arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_iam_role" "code_deploy_service_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = merge(var.common_tags,{
    Name = "${var.namespace}-${var.env}-${var.module_name}-task-exec"
  })

  lifecycle { create_before_destroy = true }
}

resource "aws_iam_role_policy_attachment" "code_deploy_role" {
  role       = aws_iam_role.code_deploy_service_role.name
  policy_arn = data.aws_iam_policy.code_deploy_service_role_policy.arn
}



resource "aws_iam_role" "lambda_role" {

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = merge(var.common_tags,{
    Name = "${var.namespace}-${var.env}-${var.module_name}-lambdas"
  })
}

resource "aws_iam_role_policy" "lambda_base_policy" {
  role = aws_iam_role.lambda_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface",
                "codedeploy:PutLifecycleEventHookExecutionStatus",
                "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}