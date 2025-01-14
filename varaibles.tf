variable "environment" {
  description = "Environment tag for resources (e.g., dev, prod)."
  type        = string
  default = "Dev"
}

variable "aws_region" {
  default = "us-gov-west-1"
}
variable "image_name" {
  default = ""
}