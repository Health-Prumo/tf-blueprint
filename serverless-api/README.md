# serverless-api

API HTTP do **API Gateway** com autorizador **JWT** (Cognito), integrada a uma **Lambda arm64** em subnets privadas.

- Lambda com role de privilégio mínimo: logs e rede da VPC (`AWSLambdaVPCAccessExecutionRole`), leitura e escrita só nas tabelas de `dynamodb_table_arns` e `bedrock:InvokeModel` só nos modelos de `bedrock_model_ids`.
- Logs da Lambda e de acesso da API no CloudWatch, com retenção de `log_retention_days` (padrão 14). O log de acesso não guarda corpo nem cabeçalhos.
- Rota `$default` protegida pelo JWT; as rotas de `public_routes` (padrão `GET /saude`) ficam abertas.
- CORS no API Gateway, que responde ao preflight sem chamar a Lambda.
- Limite de requisições no stage (`throttling_*`), como proteção de custo.
- Domínio próprio opcional (`domain_name` + `zone_id`): certificado regional do ACM, mapeamento e alias no Route 53. Com ele, o endereço `execute-api` fica desligado.

**Código da função.** O Terraform cria a Lambda com um pacote provisório (responde 503) e ignora as trocas de código. O código real é publicado pelo repositório da API com `aws lambda update-function-code`.

## Uso

```hcl
terraform {
  source = "git::https://github.com/Health-Prumo/tf-blueprint.git//serverless-api?ref=v0.5.0"
}

inputs = {
  basename            = "prumo"
  environment         = "dev"
  handler             = "prumo_api.handler.handler"
  subnet_ids          = dependency.network.outputs.private_subnet_ids
  security_group_ids  = [dependency.network.outputs.app_security_group_id]
  dynamodb_table_arns = [dependency.data.outputs.table_arn]
  bedrock_model_ids   = ["amazon.nova-micro-v1:0"]
  jwt_issuer          = dependency.auth.outputs.issuer_url
  jwt_audience        = [dependency.auth.outputs.client_id]
  cors_allow_origins  = ["https://app.exemplo.com"]
  domain_name         = "api.exemplo.com"
  zone_id             = dependency.dns.outputs.zone_id
}
```

## Entradas

| Nome | Descrição | Tipo | Padrão |
|---|---|---|---|
| `basename` | Prefixo dos nomes dos recursos | `string` | obrigatório |
| `environment` | `dev`, `hml`, `prod` ou `global` | `string` | obrigatório |
| `api_name` | Nome curto da API | `string` | `api` |
| `handler` | Função de entrada | `string` | obrigatório |
| `runtime` | Runtime da Lambda | `string` | `python3.12` |
| `memory_size` | Memória em MB | `number` | `256` |
| `timeout` | Tempo máximo em segundos (até 29) | `number` | `20` |
| `environment_variables` | Variáveis de ambiente (sem segredos) | `map(string)` | `{}` |
| `subnet_ids` | Subnets privadas (2 ou mais) | `list(string)` | obrigatório |
| `security_group_ids` | Security groups da Lambda | `list(string)` | obrigatório |
| `dynamodb_table_arns` | Tabelas com leitura e escrita | `list(string)` | `[]` |
| `bedrock_model_ids` | Modelos do Bedrock liberados | `list(string)` | `[]` |
| `log_retention_days` | Retenção dos logs | `number` | `14` |
| `jwt_issuer` | Emissor dos tokens | `string` | obrigatório |
| `jwt_audience` | Audiências aceitas | `list(string)` | obrigatório |
| `public_routes` | Rotas sem autenticação | `list(string)` | `["GET /saude"]` |
| `cors_allow_origins` | Origens do CORS | `list(string)` | obrigatório |
| `throttling_burst_limit` | Pico de requisições | `number` | `20` |
| `throttling_rate_limit` | Requisições por segundo | `number` | `10` |
| `domain_name` | Domínio próprio (opcional) | `string` | `""` |
| `zone_id` | Hosted zone do domínio | `string` | `""` |
| `tags` | Tags extras | `map(string)` | `{}` |

## Saídas

| Nome | Descrição |
|---|---|
| `function_name` | Nome da Lambda (deploy do código) |
| `function_arn` | ARN da Lambda |
| `role_arn` | ARN da role |
| `api_id` | ID da API |
| `api_endpoint` | Endereço padrão (`execute-api`) |
| `url` | Endereço público da API |
