data "aws_caller_identity" "current" {}

data "aws_ecr_repository" "main" {
  name = var.ecr_repository_name
}
# Reference outputs from the networking module
data "aws_vpc" "selected" {
  id = module.networking.vpc_id
}

locals {
  trusted_cidr_blocks = concat(
    module.networking.public_subnet_cidrs,
    module.networking.private_subnet_cidrs
  )
}

module "networking" {
  source           = "./modules/networking"
  
  # Example input values
  name                = var.name
  cidr_block          = var.cidr_block
  public_subnet_count = var.public_subnet_count
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_count = var.private_subnet_count
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = var.availability_zones
  create_nat_gateway   = var.create_nat_gateway
  create_internet_gateway = var.create_internet_gateway

  # Passing required tags
  tags = var.tags
}

module "ecs" {
  source                 = "./modules/ecs"
  cluster_name           = "dotnet-app-cluster"
  vpc_id                 = module.networking.vpc_id
  subnet_ids             = module.networking.subnet_ids
  container_image        ="${data.aws_ecr_repository.main.repository_uri}:latest" 
  security_group_ids     = [aws_security_group.ecs_service.id]
  alb_target_group_arn   = null
  tags                   = var.tags
}

module "alb" {
  source = "./modules/alb"
  vpc_id           = module.networking.vpc_id
  subnet_ids       = module.networking.subnet_ids
  ecs_service_private_ips = module.ecs.private_ips
  security_group_id     = [aws_security_group.alb.id]
  ssl_policy       = var.ssl_policy
  tags = var.tags
}

# ECS Service Security Group
resource "aws_security_group" "ecs_service" {
  name        = "ecs-service-sg"
  description = "Security group for ECS service"
  vpc_id      = module.networking.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id] # ALB communicates with ECS
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.trusted_cidr_blocks # Dynamically fetched trusted CIDRs
  }

  tags = {
    Name = "ecs-service-sg"
  }
}

# ALB Security Group
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.networking.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.trusted_cidr_blocks # Dynamically fetched trusted CIDRs
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.trusted_cidr_blocks # Dynamically fetched trusted CIDRs
  }

  egress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_service.id] # Allow traffic to ECS service
  }

  tags = {
    Name = "alb-sg"
  }
}




