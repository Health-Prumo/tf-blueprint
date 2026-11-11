# Orçamento mensal da conta com alertas por e-mail.
# include_credit = false faz o orçamento olhar o uso bruto. Sem isso os créditos do plano
# Free zeram o custo e nenhum alerta dispara até os créditos acabarem.
resource "aws_budgets_budget" "monthly" {
  name         = "${local.name}-mensal"
  budget_type  = "COST"
  limit_amount = format("%.2f", var.monthly_limit_usd)
  limit_unit   = "USD"
  time_unit    = "MONTHLY"
  tags         = var.tags

  cost_types {
    include_credit = false
    include_refund = false
  }

  dynamic "notification" {
    for_each = toset(var.alert_thresholds_usd)
    content {
      comparison_operator        = "GREATER_THAN"
      threshold                  = notification.value
      threshold_type             = "ABSOLUTE_VALUE"
      notification_type          = "ACTUAL"
      subscriber_email_addresses = var.alert_emails
    }
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.alert_emails
  }
}
