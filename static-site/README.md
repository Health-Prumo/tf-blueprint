# static-site

Site estático servido pelo CloudFront a partir de um bucket S3 privado, com HTTPS pelo ACM e o domínio no Route 53.

| Recurso | Como fica |
|---|---|
| S3 | Privado (acesso público bloqueado), criptografado, com versionamento; versões antigas expiram em 30 dias |
| CloudFront | Lê o bucket por Origin Access Control, força HTTPS, HTTP/2 e HTTP/3, compressão, cache otimizado e cabeçalhos de segurança gerenciados (HSTS, X-Frame-Options e outros) |
| ACM | Certificado do domínio (e do `www`) validado por DNS na zona informada |
| Route 53 | Alias A e AAAA do domínio (e do `www`) para a distribuição |
| CloudFront Function | Redireciona `www.<domínio>` para o domínio principal (301) |

O CloudFront só aceita certificado do ACM em `us-east-1`: rode o módulo com o provider nessa região.
O `apply` espera o certificado ser emitido, o que só acontece com o DNS do domínio já delegado à zona.

## Custo

Sem custo fixo. CloudFront no nível gratuito (1 TB e 10 milhões de requisições por mês), certificado público do ACM gratuito e S3 em centavos.

## Entradas

| Nome | Tipo | Padrão | Descrição |
|---|---|---|---|
| `basename` | `string` | — | Prefixo dos nomes |
| `environment` | `string` | — | `dev`, `hml`, `prod` ou `global` |
| `tags` | `map(string)` | `{}` | Tags extras |
| `site_name` | `string` | — | Nome curto do site (`landing`, `app`) |
| `domain_name` | `string` | — | Endereço principal do site |
| `zone_id` | `string` | — | Hosted zone do Route 53 |
| `redirect_www` | `bool` | `true` | Atende e redireciona o `www` |
| `price_class` | `string` | `PriceClass_All` | Classe de preço do CloudFront |
| `force_destroy` | `bool` | `false` | Apaga o bucket mesmo com arquivos |

## Saídas

| Nome | Descrição |
|---|---|
| `bucket_name` | Bucket onde publicar os arquivos |
| `distribution_id` | ID da distribuição, para invalidar o cache |
| `distribution_domain_name` | Endereço `*.cloudfront.net` |
| `certificate_arn` | ARN do certificado |
| `url` | Endereço público do site |

## Publicar o site

Os arquivos do site não são gerenciados pelo Terraform:

```bash
aws s3 sync ./site "s3://<bucket_name>" --delete
aws cloudfront create-invalidation --distribution-id <distribution_id> --paths "/*"
```
