provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "myrepo" {
  name = "myrepo"

  image_scanning_configuration {
    scan_on_push = true
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sh ../removeimages.sh"
  }

}

resource "null_resource" "myimage" {

  provisioner "local-exec" {
    command = "sh ../deploy.sh $aws_account"
  }
}

resource "aws_apprunner_service" "app" {
  service_name = "app"

  health_check_configuration {
    healthy_threshold   = 1
    interval            = 10
    path                = "/"
    protocol            = "TCP"
    timeout             = 5
    unhealthy_threshold = 5
  }

  source_configuration {

    auto_deployments_enabled = false

    authentication_configuration {
      access_role_arn = "arn:aws:iam::${var.aws_account}:role/service-role/AppRunnerECRAccessRole"
    }

    image_repository {
      image_identifier      = "${var.aws_account}.dkr.ecr.us-east-1.amazonaws.com/myrepo:latest"
      image_repository_type = "ECR"

      image_configuration {
        port                          = "8000"
        runtime_environment_variables = {}
      }
    }
  }
}

output "name" {
  value = aws_apprunner_service.app.service_url
}
