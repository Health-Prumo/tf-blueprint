# tf-blueprint

Módulos Terraform reutilizáveis da infraestrutura do **Prumo** (FMU Tech Inovação 2026.2).
Os ambientes que usam estes módulos ficam em [Health-Prumo/tf-environments](https://github.com/Health-Prumo/tf-environments).

## Módulos

| Módulo | O que cria |
|---|---|
| [`budgets`](budgets/) | Orçamento mensal com alertas de custo por e-mail |

Os próximos módulos (rede, banco, login, front-end e API) entram quando a infra do Prumo for provisionada. A arquitetura planejada está em [docs/06-infraestrutura-aws.md](https://github.com/Health-Prumo/prumo/blob/main/docs/06-infraestrutura-aws.md).

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
