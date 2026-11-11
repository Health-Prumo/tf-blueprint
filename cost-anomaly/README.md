# cost-anomaly

Detecção de anomalias de custo (AWS Cost Anomaly Detection), com resumo por e-mail. O serviço é gratuito.

- **Monitor** do tipo `SERVICE`: aprende o padrão de gasto de cada serviço da AWS e aponta o que sair dele.
- **Assinatura** por e-mail: avisa quando o impacto de uma anomalia passa de `impact_threshold_usd` (padrão US$ 5).

O complemento do módulo [`budgets`](../budgets/): o orçamento avisa quando o total do mês passa de um valor fixo; a anomalia avisa quando um serviço foge do padrão, mesmo com o total ainda baixo (um endpoint ou NAT esquecido ligado, por exemplo).

## Conta nova: importe o monitor padrão

A AWS cria sozinha um `Default-Services-Monitor` e uma `Default-Services-Subscription` em contas novas, e a conta só aceita **um** monitor do tipo `SERVICE`. Importe os dois antes do primeiro `apply`:

```bash
aws ce get-anomaly-monitors --query 'AnomalyMonitors[].MonitorArn'
aws ce get-anomaly-subscriptions --query 'AnomalySubscriptions[].SubscriptionArn'

terragrunt import aws_ce_anomaly_monitor.services <arn-do-monitor>
terragrunt import aws_ce_anomaly_subscription.email <arn-da-assinatura>
```

O `apply` seguinte só renomeia e ajusta o limite e os e-mails.

## Uso

```hcl
terraform {
  source = "git::https://github.com/Health-Prumo/tf-blueprint.git//cost-anomaly?ref=v0.2.0"
}

inputs = {
  basename             = "prumo"
  environment          = "global"
  impact_threshold_usd = 5
  alert_emails         = ["voce@exemplo.com"]
}
```

## Entradas

| Nome | Descrição | Tipo | Padrão |
|---|---|---|---|
| `basename` | Prefixo dos nomes dos recursos | `string` | obrigatório |
| `environment` | `dev`, `hml`, `prod` ou `global` | `string` | obrigatório |
| `impact_threshold_usd` | Impacto mínimo da anomalia, em USD, para enviar e-mail | `number` | `5` |
| `frequency` | `DAILY` ou `WEEKLY` | `string` | `DAILY` |
| `alert_emails` | De 1 a 10 e-mails | `list(string)` | obrigatório |
| `tags` | Tags extras | `map(string)` | `{}` |

## Saídas

| Nome | Descrição |
|---|---|
| `monitor_arn` | ARN do monitor |
| `subscription_arn` | ARN da assinatura |
