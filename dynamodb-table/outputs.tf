output "table_name" {
  description = "Nome da tabela."
  value       = aws_dynamodb_table.this.name
}

output "table_arn" {
  description = "ARN da tabela, usado nas políticas do IAM."
  value       = aws_dynamodb_table.this.arn
}
