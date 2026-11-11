# Detecção de anomalias de custo (Cost Anomaly Detection). Gratuito.
# O monitor olha o custo de cada serviço da AWS e aprende o padrão de gasto da conta.
# A conta só aceita um monitor do tipo SERVICE. Em conta nova a AWS já cria um
# (Default-Services-Monitor): importe-o em vez de criar outro.
resource "aws_ce_anomaly_monitor" "services" {
  name              = "${local.name}-servicos"
  monitor_type      = "DIMENSIONAL"
  monitor_dimension = "SERVICE"
  tags              = var.tags
}

# Avisa por e-mail quando o impacto de uma anomalia passa do valor definido.
resource "aws_ce_anomaly_subscription" "email" {
  name             = "${local.name}-anomalias"
  frequency        = var.frequency
  monitor_arn_list = [aws_ce_anomaly_monitor.services.arn]
  tags             = var.tags

  dynamic "subscriber" {
    for_each = toset(var.alert_emails)
    content {
      type    = "EMAIL"
      address = subscriber.value
    }
  }

  threshold_expression {
    dimension {
      key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
      match_options = ["GREATER_THAN_OR_EQUAL"]
      values        = [format("%.1f", var.impact_threshold_usd)]
    }
  }
}
