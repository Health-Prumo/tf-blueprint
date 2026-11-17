output "bucket_name" {
  description = "Bucket onde os arquivos do site são publicados."
  value       = aws_s3_bucket.site.id
}

output "distribution_id" {
  description = "ID da distribuição do CloudFront, usado para invalidar o cache após publicar."
  value       = aws_cloudfront_distribution.site.id
}

output "distribution_domain_name" {
  description = "Endereço padrão da distribuição (*.cloudfront.net)."
  value       = aws_cloudfront_distribution.site.domain_name
}

output "certificate_arn" {
  description = "ARN do certificado do ACM."
  value       = aws_acm_certificate_validation.site.certificate_arn
}

output "url" {
  description = "Endereço público do site."
  value       = "https://${var.domain_name}"
}
