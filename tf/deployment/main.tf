resource "aws_codedeploy_app" "service" {
  compute_platform = "ECS"
  name             = "${var.namespace}-${var.env}-${var.module_name}"
}

resource "aws_codedeploy_deployment_group" "service" {
  deployment_group_name  = "${var.namespace}-${var.env}-${var.module_name}"
  service_role_arn       = aws_iam_role.code_deploy_service_role.arn

  app_name               = aws_codedeploy_app.service.name
  deployment_config_name = var.deployment_config

  auto_rollback_configuration {
    enabled = true
    events  = [ "DEPLOYMENT_FAILURE" ]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
//      wait_time_in_minutes = 3
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster.name
    service_name = var.ecs_service.name
  }

  load_balancer_info {
    target_group_pair_info {

      prod_traffic_route { listener_arns = [var.listener_prod.arn] }
      test_traffic_route { listener_arns = [var.listener_test.arn] }

      target_group { name = var.tg_blue.name }
      target_group { name = var.tg_green.name }
    }
  }
}