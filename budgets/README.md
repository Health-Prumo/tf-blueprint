# budgets

Orçamento mensal da conta com alertas de custo por e-mail.

- Um alerta por valor de **gasto real** em `alert_thresholds_usd` (padrão: US$ 20 e US$ 40).
- Um alerta de **previsão**: avisa quando a AWS projeta que o mês vai passar de `monthly_limit_usd`.
- Os créditos **não** abatem o custo (`include_credit = false`). No plano Free os créditos zeram a fatura, e sem isso nenhum alerta dispararia até os créditos acabarem.

Os dois primeiros orçamentos da conta não têm custo.

## Uso

```hcl
terraform {
  source = "git::https://github.com/Health-Prumo/tf-blueprint.git//budgets?ref=v0.1.0"
}

inputs = {
  basename             = "prumo"
  environment          = "global"
  monthly_limit_usd    = 40
  alert_thresholds_usd = [20, 40]
  alert_emails         = ["voce@exemplo.com"]
}
```

## Entradas

| Nome | Descrição | Tipo | Padrão |
|---|---|---|---|
| `basename` | Prefixo dos nomes dos recursos | `string` | obrigatório |
| `environment` | `dev`, `hml`, `prod` ou `global` | `string` | obrigatório |
| `monthly_limit_usd` | Limite mensal em USD, base do alerta de previsão | `number` | obrigatório |
| `alert_thresholds_usd` | Valores de gasto real que disparam e-mail | `list(number)` | `[20, 40]` |
| `alert_emails` | E-mails que recebem os alertas | `list(string)` | obrigatório |
| `tags` | Tags extras | `map(string)` | `{}` |

## Saídas

| Nome | Descrição |
|---|---|
| `budget_name` | Nome do orçamento criado |
