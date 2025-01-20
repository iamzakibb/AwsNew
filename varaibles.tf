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

variable "aws_region" {
  default = "us-gov-west-1"
}
variable "image_name" {
  default = ""
}