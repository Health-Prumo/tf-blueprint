output "monitor_arn" {
  description = "ARN do monitor de anomalias."
  value       = aws_ce_anomaly_monitor.services.arn
}

output "subscription_arn" {
  description = "ARN da assinatura de e-mail."
  value       = aws_ce_anomaly_subscription.email.arn
}
