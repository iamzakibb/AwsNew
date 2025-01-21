variable "environment" {
  description = "Environment tag for resources (e.g., dev, prod)."
  type        = string
  default = "Dev"
}
variable "tags" {
  default = {
    "CI Environment"          = "production" # Change based on your environment
    "Information Classification" = "confidential"
    "AppServiceTag"           = "approved-value" # Replace 'approved-value' with a valid value
  }
}
variable "name" {
  description = "The name of the network"
  type        = string
  default     = "my-network"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-west-1a", "us-west-1b"]
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 2
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "private_subnet_count" {
  description = "Number of private subnets"
  type        = number
  default     = 2
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["192.168.3.0/24", "192.168.4.0/24"]
}

variable "create_nat_gateway" {
  description = "Flag to create NAT Gateway"
  type        = bool
  default     = true
}

variable "create_internet_gateway" {
  description = "Flag to create Internet Gateway"
  type        = bool
  default     = true
}
variable "ecr_repository_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = ""
  
}
variable "aws_region" {
  default = "us-gov-west-1"
}
variable "image_name" {
  default = ""
}
variable "tg_port" {
  default = "80"
}
variable "tg_protocol" {
  default = "HTTP"
}
variable "lb_port" {
  type = string
  default = "443"
}
variable "lb_protocol" {
  type = string
  default = "HTTPS"
}
variable "ssl_policy" {
  default = ""
}
variable "target_type" {
  default = "ip"
}
variable "trusted_cidr_blocks" {
  type        = list(string)
  description = "List of trusted CIDR blocks for ALB and ECS communication"
  default     = ["192.168.0.0/16"] 
}
