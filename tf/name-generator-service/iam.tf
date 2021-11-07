# Standard IAM Policy for ECS task
data "aws_iam_policy" "ecs-task-execution-policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Task execution role
resource "aws_iam_role" "task_execution" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = merge(var.common_tags,{
    Name = "${var.namespace}-${var.env}-${var.module_name}-task-exec"
  })

  lifecycle { create_before_destroy = true }
}

# TODO: Restrict this further
resource "aws_iam_policy" "task_execution_inline" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "ssm:GetParameters",
        "ssm:GetParameter"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF


  lifecycle { create_before_destroy = true }
}

resource "aws_iam_role_policy_attachment" "task_execution1" {
  role       = aws_iam_role.task_execution.name
  policy_arn = data.aws_iam_policy.ecs-task-execution-policy.arn
}

resource "aws_iam_role_policy_attachment" "task_execution2" {
  role       = aws_iam_role.task_execution.name
  policy_arn = aws_iam_policy.task_execution_inline.arn
}