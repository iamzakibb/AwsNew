data "aws_network_interface" "ecs_eni" {
  for_each = toset(aws_ecs_service.main.network_configuration[0].assign_public_ip == false ? aws_ecs_service.main.network_configuration[0].subnets : [])
  id       = each.value
}

output "private_ips" {
  value = [for eni in data.aws_network_interface.ecs_eni : eni.private_ips]
}
