# Terraform Cloud config
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "lokalise-interview"

    workspaces {
      prefix = "lokalise-"
    }
  }
}

# AWS provider
provider "aws" {
  region = var.region
}

# global vars and locals
variable "namespace" {}
variable "region" {}
variable "env" {}

locals {

  common_tags = {
    env         = var.env
    region      = var.region
    project     = var.namespace
    managed_by  = "tf"
  }
}


# ECS cluster
resource "aws_ecs_cluster" "services" {
  name = "${var.namespace}-${var.env}"
  tags = local.common_tags
}

# S3 Bucket for CodeDeploy appspec files
resource "aws_s3_bucket" "heatmap" {
  bucket = "${var.namespace}-${var.env}-appspec"
  versioning {
    enabled = true
  }

  tags = local.common_tags
}