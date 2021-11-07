variable "proj_name" {}
variable "env" {}
variable "module_name" {}
variable "common_tags" {type = map(string)}

variable "vpc" {}
variable "subnets" {type = set(string)}

variable "tg_blue" {}
variable "tg_green" {}