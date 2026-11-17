output "zone_id" {
  description = "ID da hosted zone, usado pelos outros módulos para criar registros."
  value       = aws_route53_zone.this.zone_id
}

output "zone_arn" {
  description = "ARN da hosted zone."
  value       = aws_route53_zone.this.arn
}

output "name_servers" {
  description = "Nameservers da zona. Configure estes quatro na registradora do domínio."
  value       = aws_route53_zone.this.name_servers
}
