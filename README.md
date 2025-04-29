# AWS ECS Terraform Project

This project provides a modular Terraform infrastructure for deploying containers on AWS ECS with Fargate.

## Architecture
- VPC with public and private subnets across multiple availability zones
- Application Load Balancer (ALB) in public subnets
- ECS Fargate service in private subnets
- Auto scaling policies based on CPU and memory utilisation
- Security groups for restricting traffic

## Modules
- networking: VPC, subnets, NAT gateway, route tables
- security: Security groups and IAM roles
- alb: Application Load Balancer setup
- ecs: ECS cluster, task definition, service, and auto scaling
