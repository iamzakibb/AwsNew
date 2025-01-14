data "aws_caller_identity" "current" {}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default = "dev-cluster90909ff"
}

variable "vpc_id" {
  description = "VPC ID where ECS resources will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS service"
  type        = list(string)
  
}
variable "alb_target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}


variable "security_group_ids" {
  description = "List of security group IDs for ECS service"
  type        = list(string)
}
variable "container_image" {
  description = "The container image to be pulled by the ECS service"
  type        = string
}
