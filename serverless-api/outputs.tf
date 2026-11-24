output "function_name" {
  description = "Nome da função Lambda (usado no deploy do código)."
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "ARN da função Lambda."
  value       = aws_lambda_function.this.arn
}

output "role_arn" {
  description = "ARN da role da Lambda."
  value       = aws_iam_role.lambda.arn
}

output "api_id" {
  description = "ID da API HTTP."
  value       = aws_apigatewayv2_api.this.id
}

output "api_endpoint" {
  description = "Endereço padrão da API (desligado quando há domínio próprio)."
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "url" {
  description = "Endereço público da API."
  value       = local.custom_domain ? "https://${var.domain_name}" : aws_apigatewayv2_api.this.api_endpoint
}
