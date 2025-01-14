data "aws_caller_identity" "current" {}


module "ecs" {
  source                 = "./modules/ecs"
  cluster_name           = "dotnet-app-cluster"
  vpc_id                 = ""
  subnet_ids             = ["",""]
  container_image        = var.image_name
  security_group_ids     = [""]
  alb_target_group_arn   = null

}

module "alb" {
  source                = "./modules/alb"
  vpc_id                = module.networking.vpc_id
  subnet_ids            = module.networking.subnet_ids
  security_group_id     = [aws_security_group.alb.id]
  ecs_service_private_ips = module.ecs.private_ips  
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



