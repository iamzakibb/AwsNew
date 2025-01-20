data "aws_caller_identity" "current" {}

module "networking" {
  source           = "./modules/networking"
  
  # Example input values
  name                 = "my-network"
  cidr_block           = "192.168.0.0/16"
  availability_zones   = ["us-west-1a", "us-west-1b"]
  public_subnet_count  = 2
  public_subnet_cidrs  = ["192.168.1.0/24", "192.168.2.0/24"]
  private_subnet_count = 2
  private_subnet_cidrs = ["192.168.3.0/24", "192.168.4.0/24"]
  create_nat_gateway   = true
  create_internet_gateway = true

  # Passing required tags
  tags = var.tags
}

module "ecs" {
  source                 = "./modules/ecs"
  cluster_name           = "dotnet-app-cluster"
  vpc_id                 = module.networking.vpc_id
  subnet_ids             = module.networking.subnet_ids
  container_image        = var.image_name
  security_group_ids     = [aws_security_group.ecs_service.id]
  alb_target_group_arn   = null
  tags                   = var.tags
}

module "alb" {
  source                = "./modules/alb"
  vpc_id                = module.networking.vpc_id
  subnet_ids            = module.networking.subnet_ids
  security_group_id     = [aws_security_group.alb.id]
  ecs_service_private_ips = module.ecs.private_ips  
  tags                   = var.tags
}

resource "aws_security_group" "ecs_service" {
  name        = "ecs-service-sg"
  description = "Security group for ECS service"
  vpc_id      = module.networking.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
   security_groups = [aws_security_group.alb.id]
  }
 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.networking.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows HTTP traffic from the internet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



