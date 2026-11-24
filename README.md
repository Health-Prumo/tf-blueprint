# tf-blueprint

Módulos Terraform reutilizáveis da infraestrutura do **Prumo** (FMU Tech Inovação 2026.2).
Os ambientes que usam estes módulos ficam em [Health-Prumo/tf-environments](https://github.com/Health-Prumo/tf-environments).

## Módulos

| Módulo | O que cria |
|---|---|
| [`budgets`](budgets/) | Orçamento mensal com alertas de custo por e-mail |
| [`cost-anomaly`](cost-anomaly/) | Detecção de anomalias de custo com resumo diário por e-mail |
| [`dns-zone`](dns-zone/) | Zona pública no Route 53 (delegação de DNS) com proteção contra e-mail falso |
| [`static-site`](static-site/) | Site estático ou SPA com S3 privado, CloudFront, certificado do ACM e domínio no Route 53 |
| [`network`](network/) | VPC privada sem NAT, com gateway endpoint do DynamoDB e interface endpoints (Bedrock Runtime e Logs) |
| [`dynamodb-table`](dynamodb-table/) | Tabela única do DynamoDB on-demand com TTL |
| [`cognito-auth`](cognito-auth/) | Login por e-mail e senha no Cognito (plano Lite) com app client público |
| [`serverless-api`](serverless-api/) | API HTTP com autorizador JWT, Lambda arm64 na VPC, logs e domínio próprio |

A arquitetura está em [docs/06-infraestrutura-aws.md](https://github.com/Health-Prumo/prumo/blob/main/docs/06-infraestrutura-aws.md).

## Convenções

- Um diretório por módulo, com `versions.tf`, `variables.tf`, `locals.tf`, `main.tf`, `outputs.tf` e `README.md`.
- Toda variável e saída tem `description` e tipo, e as entradas críticas têm `validation`.
- Todo módulo recebe `basename`, `environment` e `tags`. Os nomes seguem `<basename>-<environment>-<recurso>`.
- Provider AWS `~> 6.0` e Terraform `>= 1.10`. O provider não é declarado aqui, ele é gerado pelo Terragrunt no `tf-environments`.
- Versionamento por tag semântica (`v0.1.0`). Os ambientes sempre apontam para uma tag, nunca para a `main`.

## Como lançar uma versão

```bash
terraform fmt -recursive
git tag v0.X.Y && git push origin v0.X.Y
```

Depois, atualize o `?ref=` no `tf-environments`.
