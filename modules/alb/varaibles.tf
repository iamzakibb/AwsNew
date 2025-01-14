variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}


variable "ecs_service_private_ips" {
  type = list(string)
}

variable "security_group_id" {
  type = list(string)
  default = [ "" ]
}