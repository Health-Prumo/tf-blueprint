# cognito-auth

Login com e-mail e senha no **Amazon Cognito**, plano **Lite**.

- User pool com o e-mail como nome de usuário (sem diferenciar maiúsculas) e verificação por código enviado por e-mail.
- Senha com no mínimo 8 caracteres, letra minúscula e número. Recuperação de conta pelo e-mail.
- E-mails pelo próprio Cognito (`COGNITO_DEFAULT`, limite de 50 por dia), com o texto em português.
- App client **público** (sem segredo), com `USER_PASSWORD_AUTH`, `USER_SRP_AUTH` e `REFRESH_TOKEN_AUTH`, e revogação de token.
- Proteção contra exclusão ligada por padrão.

O `client_id` não é segredo: ele vai para o front-end. O `issuer_url` e o `client_id` configuram o autorizador JWT do API Gateway.

## Uso

```hcl
terraform {
  source = "git::https://github.com/Health-Prumo/tf-blueprint.git//cognito-auth?ref=v0.5.0"
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
| `app_name` | Nome exibido nos e-mails | `string` | `Prumo` |
| `deletion_protection` | Proteção contra exclusão | `bool` | `true` |
| `id_token_validity_minutes` | Validade do ID e do access token | `number` | `60` |
| `refresh_token_validity_days` | Validade do refresh token | `number` | `30` |
| `tags` | Tags extras | `map(string)` | `{}` |

## Saídas

| Nome | Descrição |
|---|---|
| `user_pool_id` | ID do user pool |
| `user_pool_arn` | ARN do user pool |
| `client_id` | App client do front |
| `issuer_url` | Emissor dos tokens (autorizador JWT) |
