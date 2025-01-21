output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public.*.id
}

output "public_subnet_id_a" {
  description = "First public subnet ID"
  value       = aws_subnet.public[0].id
}

output "public_subnet_id_b" {
  description = "Second public subnet ID"
  value       = aws_subnet.public[1].id
}
output "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  value       = aws_subnet.private.*.cidr_block
}
output "subnet_ids" {
  description = "List of all subnet IDs (public and private)"
  value       = concat(aws_subnet.public.*.id, aws_subnet.private.*.id)
}
output "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  value       = aws_subnet.public.*.cidr_block
}
