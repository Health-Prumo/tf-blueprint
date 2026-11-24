output "user_pool_id" {
  description = "ID do user pool."
  value       = aws_cognito_user_pool.this.id
}

output "user_pool_arn" {
  description = "ARN do user pool."
  value       = aws_cognito_user_pool.this.arn
}

output "client_id" {
  description = "ID do app client web (público, vai para o front)."
  value       = aws_cognito_user_pool_client.web.id
}

output "issuer_url" {
  description = "Emissor dos tokens, usado pelo autorizador JWT do API Gateway."
  value       = "https://cognito-idp.${data.aws_region.current.region}.amazonaws.com/${aws_cognito_user_pool.this.id}"
}
