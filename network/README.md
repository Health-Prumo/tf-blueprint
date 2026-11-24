# network

Rede privada da aplicação, **sem NAT Gateway e sem internet gateway**.

- VPC (padrão `10.0.0.0/16`) com uma subnet privada `/20` por AZ (padrão: 2 AZs). A metade superior da faixa fica reservada para subnets públicas, que não são criadas.
- Security group `app` para as funções Lambda: só saída HTTPS.
- **DynamoDB por gateway endpoint** (sem custo).
- **Interface endpoints** para os serviços de `interface_endpoint_services` (padrão: `bedrock-runtime` e `logs`), com DNS privado. Cada um custa cerca de US$ 0,01 por hora **por AZ** (2 serviços × 2 AZs ≈ US$ 29,20/mês). Passe uma lista vazia para desligar todos.
- O security group padrão da VPC fica sem regras.

## Uso

```hcl
terraform {
  source = "git::https://github.com/Health-Prumo/tf-blueprint.git//network?ref=v0.5.0"
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
| `cidr_block` | Faixa da VPC (/16 a /20) | `string` | `10.0.0.0/16` |
| `az_count` | AZs com subnet privada (2 ou 3) | `number` | `2` |
| `interface_endpoint_services` | Serviços com interface endpoint; `[]` desliga | `list(string)` | `["bedrock-runtime", "logs"]` |
| `tags` | Tags extras | `map(string)` | `{}` |

## Saídas

| Nome | Descrição |
|---|---|
| `vpc_id` | ID da VPC |
| `private_subnet_ids` | Subnets privadas |
| `app_security_group_id` | Security group das funções Lambda |
| `interface_endpoints` | IDs dos interface endpoints por serviço |
