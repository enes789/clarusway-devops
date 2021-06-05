provider "aws" {
  region = var.AWS_REGION
}

################################################################################################################
# First Create a s3 bucket, using the following command:
# aws s3api create-bucket --acl private --bucket terraform-artifacts-test
# aws s3api put-bucket-versioning --bucket terraform-artifacts-test --versioning-configuration Status=Enabled
################################################################################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.42.0"
    }
  }

  # backend "s3" {
  #   bucket = "terraform-artifacts-nitroex"
  #   key    = "test/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

module "internet-facing-alb" {
  source                     = "../modules/alb"
  VPC_ID                     = "vpc-d962cca4"
  ALB_NAME                   = var.external_alb_name
  //ALB_SUBNETS              = module.vpc.alb_subnet_id
  ALB_SUBNETS                = ["subnet-6c1c8e0a", "subnet-d07d509d"]
  //ALB_SUBNETS                = join(",", module.vpc.alb_subnet_id)
  DEFAULT_TARGET_ARN         = module.target-group.target_group_arn
  INTERNAL                   = "false"
}

module "target-group" {
  source        = "../modules/target-group"
}

module "alb-listener" {
  source           = "../modules/alb-listener"
  TARGET_GROUP_ARN = module.target-group.target_group_arn
}

module "launch-template" {
  source        = "../modules/launch-template"
  ALB_SEC_GROUP = module.internet-facing-alb.sg_id
}

module "asg" {
  source             = "../modules/asg"
  LAUNCH_TEMPLATE_ID = module.launch-template.id
}