provider "aws" {
  region = "eu-west-2"
}

## S3 State
module "state" {
  source                              = "./modules/state"
  s3_tfstate_bucket                   = "cloud-octo-tfstate"
  dynamo_db_table_name                = "cloud-octo-lock"
}

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
