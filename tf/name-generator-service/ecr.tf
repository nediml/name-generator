resource "aws_ecr_repository" "ecr" {
  name = "${var.namespace}-${var.env}-${var.module_name}"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.common_tags
}

# ECR Policy
resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr.name

  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last ${var.svc_images_to_keep} images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": ${var.svc_images_to_keep}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF

}