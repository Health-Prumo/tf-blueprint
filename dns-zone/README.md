# dns-zone

Hosted zone pública no Route 53 para um domínio registrado em outra empresa (delegação de DNS).
O domínio continua registrado onde foi comprado. Só os nameservers apontam para a AWS.

Por padrão também protege o domínio contra e-mail falso, já que ele não usa e-mail:

| Registro | Valor | Efeito |
|---|---|---|
| TXT na raiz | `v=spf1 -all` | Nenhum servidor pode enviar e-mail pelo domínio |
| TXT `_dmarc` | `v=DMARC1; p=reject; adkim=s; aspf=s` | Quem recebe rejeita e-mail que diga vir do domínio |
| MX | `0 .` | MX nulo (RFC 7505): o domínio não recebe e-mail |

## Custo

US$ 0,50 por zona por mês, mais US$ 0,40 por milhão de consultas.

## Entradas

| Nome | Tipo | Padrão | Descrição |
|---|---|---|---|
| `basename` | `string` | — | Prefixo dos nomes |
| `environment` | `string` | — | `dev`, `hml`, `prod` ou `global` |
| `tags` | `map(string)` | `{}` | Tags extras da zona |
| `domain_name` | `string` | — | Domínio, sem ponto no final |
| `block_email` | `bool` | `true` | Cria SPF, DMARC e MX nulo |
| `apex_txt_records` | `list(string)` | `[]` | TXT extras na raiz (a raiz aceita um só conjunto TXT) |

## Saídas

| Nome | Descrição |
|---|---|
| `zone_id` | ID da zona, para outros módulos criarem registros |
| `zone_arn` | ARN da zona |
| `name_servers` | Os quatro nameservers para configurar na registradora |

## Delegação

1. Aplique o módulo e pegue `name_servers` (`terragrunt output name_servers`).
2. Na registradora, troque os nameservers padrão por esses quatro.
3. Confira a propagação: `dig NS <domínio> +short`.
