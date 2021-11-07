variable "account_id" {}
variable "region" {}

variable "namespace" {}
variable "env" {}
variable "module_name" {}
variable "common_tags" {type = map(string)}

variable "svc_cpu" { type = number }
variable "svc_memory" { type = number }
variable "svc_port" { type = number }
variable "svc_images_to_keep" { type = number }

variable "svc_health_check_path" {}
variable "svc_health_check_grace_period" { type = number }

variable "vpc" {}
variable "subnets" {type = set(string)}
variable "ecs_cluster_arn" {}

variable "alb" {}
variable "alb_sgs" {type = set(string)}
