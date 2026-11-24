# Tabela única on-demand: PK (partição) e SK (ordenação), ambas string.
# Exemplo do Prumo: PK = USUARIO#<id>, SK = PERFIL | DIA#<aaaa-mm-dd> | CHAT#<timestamp>.
# Criptografia em repouso com a chave da própria AWS (padrão, sem custo).

resource "aws_dynamodb_table" "this" {
  name                        = local.name
  billing_mode                = "PAY_PER_REQUEST"
  hash_key                    = "PK"
  range_key                   = "SK"
  deletion_protection_enabled = var.deletion_protection
  tags                        = var.tags

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

  ttl {
    enabled        = var.ttl_attribute != ""
    attribute_name = var.ttl_attribute
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery
  }
}
