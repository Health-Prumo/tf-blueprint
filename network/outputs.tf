output "vpc_id" {
  description = "ID da VPC."
  value       = aws_vpc.this.id
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas, uma por AZ."
  value       = aws_subnet.private[*].id
}

output "app_security_group_id" {
  description = "Security group das funções Lambda da aplicação."
  value       = aws_security_group.app.id
}

output "interface_endpoints" {
  description = "Interface endpoints criados, por serviço."
  value       = { for k, v in aws_vpc_endpoint.interface : k => v.id }
}
