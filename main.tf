provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      Environment = "dev"
    }
  }
}

## S3 State
module "state" {
  source               = "./modules/state"
  s3_tfstate_bucket    = "cloud-octo-tfstate"
  dynamo_db_table_name = "cloud-octo-lock"
}

# VPC
module "vpc" {
  source = "./modules/vpc"
}

# ECR
module "ecr" {
  source = "./modules/ecr"
  name   = "cloud-octo"
}

# Apigateway Logs
module "apigateway_logs" {
  source = "./modules/logs"
  name   = "cloud-octo-logs"
}

resource "aws_security_group" "rds" {
  name        = "rds-security-group"
  description = "Allows outbound access only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = "5432"
    to_port         = "5432"
    security_groups = [module.apigateway.ecs_security_group_id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Apigateway DB
module "apigateway_rds" {
  source            = "./modules/rds"
  rds_db_name       = var.db_name
  rds_username      = var.rds_username
  rds_password      = var.rds_password
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnet_ids
  security_group_id = aws_security_group.rds.id
}

data "template_file" "apigateway" {
  template = file("templates/apigateway.tpl")

  vars = {
    docker_image_url_django = module.ecr.repository_url
    region                  = "eu-west-2"
    tag                     = "latest"
    log_group_name          = module.apigateway_logs.log_group_name
    log_stream_name         = module.apigateway_logs.log_stream_name
    db_name                 = module.apigateway_rds.rds_db_name
    db_username             = var.rds_username
    db_password             = var.rds_password
    db_host                 = module.apigateway_rds.rds_host
    db_port                 = module.apigateway_rds.rds_port
    order_queue_url         = "localhost"
    apigateway_secret       = var.apigateway_secret
    debug                   = var.debug
    allowed_hosts           = var.allowed_hosts
  }
}

# Apigateway
module "apigateway" {
  vpc_id             = module.vpc.vpc_id
  source             = "./modules/load_balanced_cluster"
  ecs_cluster_name   = "apigateway"
  container_name     = "apigateway"
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  template_file      = data.template_file.apigateway.rendered
}

module "bastion_migrator" {
  source     = "./modules/bastion"
  key_name   = "bastion-key"
  public_key = var.public_key
  vpc_id     = module.vpc.vpc_id
}

# resource "aws_iam_role" "rds_migration_role" {
#   name = "rds_migratior"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# # RDS migrator lambda
# module "rds_migrator" {
#   source = "./modules/lambda"
#   name   = "cloud-octo-rds-migrator"
#   role_arn = aws_iam_role.rds_migration_role.arn
# }

## Repo
# module "codecommit" {
#   source          = "./modules/code_commit"
#   repository_name = "CloudOctoInfraRepo"
# }

# 
# module "codebuild" {
#   source                                 = "./modules/code_build"
#   codebuild_project_terraform_plan_name  = "TerraformPlan"
#   codebuild_project_terraform_apply_name = "TerraformApply"
#   codebuild_terraform_security_name      = "TerraformSecurity"
#   s3_logging_bucket_id                   = module.state.s3_logging_bucket_id
#   codebuild_iam_role_arn                 = module.state.codebuild_iam_role_arn
#   s3_logging_bucket                      = module.state.s3_logging_bucket
# }

# Creates
# * Artifact Bucket
# * role that permits pipeline to assume
# * Steps: pull code from git, terraform plan, manual approval, apply
# module "codepipeline" {
#   source                               = "./modules/code_pipeline"
#   tf_codepipeline_name                 = "TerraformCodePipeline"
#   tf_codepipeline_artifact_bucket_name = "cloud-octo-codebuild-artifact-bucket"
#   tf_codepipeline_role_name            = "TerraformCodePipelineIamRole"
#   tf_codepipeline_role_policy_name     = "TerraformCodePipelineIamRolePolicy"
#   terraform_codecommit_repo_name       = module.codecommit.terraform_codecommit_repo_name
#   codebuild_terraform_plan_name        = module.codebuild.codebuild_terraform_plan_name
#   codebuild_terraform_apply_name       = module.codebuild.codebuild_terraform_apply_name
#   codebuild_terraform_security_name    = module.codebuild.codebuild_terraform_security_name
# }
