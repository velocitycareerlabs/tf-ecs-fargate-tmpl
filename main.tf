provider "aws" {
  access_key = var.aws-access-key
  secret_key = var.aws-secret-key
  region     = var.aws-region
}

terraform {
  backend "s3" {
    bucket  = "vcl-terraform-backend-store"
    encrypt = true
    key     = "terraform.tfstate"
    region  = "us-east-1"
    dynamodb_table = "terraform-state-lock-dynamo" #- uncomment this line once the terraform-state-lock-dynamo has been terraformed
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}

module "vpc" {
  source             = "./vpc"
  name               = var.name
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}

module "secrets" {
  source              = "./secrets"
  name                = var.name
  environment         = var.environment
  application-secrets = var.application-secrets
}

module "ecs-cluster" {
  source              = "./ecs-cluster"
  name                = var.name
  environment         = var.environment
}

module "security_groups" {
  for_each = var.services

  source         = "./security-groups"
  name           = "${var.name}-${each.key}"
  vpc_id         = module.vpc.id
  environment    = var.environment
  container_port = var.container_port
}

module "alb" {
  for_each = var.services

  source              = "./alb"
  name                = "${var.name}-${each.key}"
  vpc_id              = module.vpc.id
  subnets             = module.vpc.public_subnets
  environment         = var.environment
  alb_security_groups = [module.security_groups[each.key].alb]
  alb_tls_cert_arn    = var.tls_certificate_arn
  health_check_path   = var.health_check_path
}

module "ecr" {
  for_each = var.services

  source      = "./ecr"
  name           = "${var.name}-${each.key}"
  environment = var.environment
}

module "ecs" {
  for_each = var.services

  source                      = "./ecs"
  ecs_cluster                 = module.ecs-cluster.ecs_cluster
  name                        = "${var.name}-${each.key}"
  environment                 = var.environment
  region                      = var.aws-region
  subnets                     = module.vpc.private_subnets
  aws_alb_target_group_arn    = module.alb[each.key].aws_alb_target_group_arn
  ecs_service_security_groups = [module.security_groups[each.key].ecs_tasks]
  container_port              = var.container_port
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  service_desired_count       = var.service_desired_count
  container_environment  = each.value.vars
  container_image        = module.ecr[each.key].aws_ecr_repository_url
  container_secrets      = module.secrets.secrets_map
  container_secrets_arns = module.secrets.application_secrets_arn
}

