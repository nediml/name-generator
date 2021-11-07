variable "ngs_cpu" { type = number }
variable "ngs_memory" { type = number }
variable "ngs_port" { type = number }
variable "ngs_images_to_keep" { type = number }

variable "ngs_health_check_path" {}
variable "ngs_health_check_grace_period" { type = number }

###############################################################
# SERVICE
###############################################################

module "ngs" {
  source = "./name-generator-service/"

  account_id = data.aws_caller_identity.current.account_id
  region     = var.region

  namespace   = var.namespace
  env         = var.env
  module_name = "ngs"
  common_tags = local.common_tags

  svc_cpu            = var.ngs_cpu
  svc_memory         = var.ngs_memory
  svc_port           = var.ngs_port
  svc_images_to_keep = var.ngs_images_to_keep

  svc_health_check_path         = var.ngs_health_check_path
  svc_health_check_grace_period = var.ngs_health_check_grace_period

  vpc     = aws_default_vpc.default.id
  subnets = [
    aws_default_subnet.default_az1.id,
    aws_default_subnet.default_az2.id,
    aws_default_subnet.default_az2.id
  ]

  ecs_cluster_arn = aws_ecs_cluster.services.arn

  alb     = module.router.alb
  alb_sgs = module.router.alb.security_groups

}

###############################################################
# ROUTER
###############################################################

module "router" {
  //  count = 1
  source = "./router/"

  proj_name   = var.namespace
  env         = var.env
  module_name = "router"
  common_tags = local.common_tags

  //  domain_cert_arn = data.aws_acm_certificate.lb_public.arn

  vpc = aws_default_vpc.default.id
  subnets = [
    aws_default_subnet.default_az1.id,
    aws_default_subnet.default_az2.id,
    aws_default_subnet.default_az2.id
  ]

  tg_blue = module.ngs.tg_blue
  tg_green = module.ngs.tg_green
}


###############################################################
# DEPLOY
###############################################################

module "deployment" {
  source = "./deployment/"

  account_id = data.aws_caller_identity.current.account_id
  region     = var.region

  namespace   = var.namespace
  env         = var.env
  module_name = "ngs-deploy"
  common_tags = local.common_tags

  deployment_config = "CodeDeployDefault.ECSAllAtOnce"

  ecs_cluster = aws_ecs_cluster.services
  ecs_service = module.ngs.ecs_service

  listener_prod = module.router.listener_prod
  listener_test = module.router.listener_test

  tg_blue  = module.ngs.tg_blue
  tg_green = module.ngs.tg_green
}
