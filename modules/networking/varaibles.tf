# General Tags for Resources
variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources."
}

# VPC Configuration
variable "name" {
  type        = string
  description = "Name prefix for all resources."
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

# Availability Zones
variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones to use."
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"] # Modify as per your region
}

# Public Subnet Configuration
variable "public_subnet_count" {
  type        = number
  description = "Number of public subnets to create."
  default     = 3
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets."
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] # Modify as per your plan
}

# Private Subnet Configuration
variable "private_subnet_count" {
  type        = number
  description = "Number of private subnets to create."
  default     = 3
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets."
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] # Modify as per your plan
}

# NAT Gateway
variable "create_nat_gateway" {
  type        = bool
  description = "Whether to create a NAT gateway."
  default     = true
}

# Internet Gateway
variable "create_internet_gateway" {
  type        = bool
  description = "Whether to create an internet gateway."
  default     = true
}
