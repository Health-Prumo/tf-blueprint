# dynamodb-table

Tabela única do DynamoDB, **on-demand** (paga só pelo uso).

- Chaves `PK` (partição) e `SK` (ordenação), ambas string.
- TTL no atributo `ttl_attribute` (padrão `expira_em`, epoch em segundos).
- Criptografia em repouso com a chave da AWS (padrão, sem custo).
- Proteção contra exclusão ligada por padrão. Para destruir, passe `deletion_protection = false` e aplique antes.
- PITR desligado por padrão (é cobrado por GB).

## Uso

```hcl
terraform {
  source = "git::https://github.com/Health-Prumo/tf-blueprint.git//dynamodb-table?ref=v0.5.0"
}

inputs = {
  basename    = "prumo"
  environment = "dev"
}
```

## Entradas

| Nome | Descrição | Tipo | Padrão |
|---|---|---|---|
| `basename` | Prefixo dos nomes dos recursos | `string` | obrigatório |
| `environment` | `dev`, `hml`, `prod` ou `global` | `string` | obrigatório |
| `table_name` | Nome curto da tabela | `string` | `dados` |
| `ttl_attribute` | Atributo do TTL; vazio desliga | `string` | `expira_em` |
| `point_in_time_recovery` | Backup contínuo | `bool` | `false` |
| `deletion_protection` | Proteção contra exclusão | `bool` | `true` |
| `tags` | Tags extras | `map(string)` | `{}` |

## Saídas

| Nome | Descrição |
|---|---|
| `table_name` | Nome da tabela (`<basename>-<environment>-<table_name>`) |
| `table_arn` | ARN da tabela |
