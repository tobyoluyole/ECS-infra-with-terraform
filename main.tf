provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "./modules/networking"
  
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  project_name         = var.project_name
  environment          = var.environment
}

module "security" {
  source = "./modules/security"
  
  vpc_id       = module.networking.vpc_id
  project_name = var.project_name
  environment  = var.environment
  container_port = var.container_port
}

module "alb" {
  source = "./modules/alb"
  
  vpc_id              = module.networking.vpc_id
  public_subnets      = module.networking.public_subnet_ids
  security_group_id   = module.security.alb_security_group_id
  project_name        = var.project_name
  environment         = var.environment
  health_check_path   = var.health_check_path
}

module "ecs" {
  source = "./modules/ecs"
  
  project_name              = var.project_name
  environment               = var.environment
  vpc_id                    = module.networking.vpc_id
  private_subnet_ids        = module.networking.private_subnet_ids
  ecs_service_security_group_id = module.security.ecs_security_group_id
  alb_target_group_arn      = module.alb.target_group_arn
  container_port            = var.container_port
  container_image           = var.container_image
  cpu_allocation            = var.cpu_allocation
  memory_allocation         = var.memory_allocation
  desired_count             = var.desired_count
  execution_role_arn        = module.security.ecs_execution_role_arn
  task_role_arn             = module.security.ecs_task_role_arn
}