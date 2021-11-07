variable "account_id" {}
variable "region" {}

variable "namespace" {}
variable "env" {}
variable "module_name" {}
variable "common_tags" {type = map(string)}

variable "deployment_config" {}

variable "ecs_cluster" {}
variable "ecs_service" {}

variable "listener_prod" {}
variable "listener_test" {}

variable "tg_blue" {}
variable "tg_green" {}