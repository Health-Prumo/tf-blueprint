# Rede privada da aplicação, sem NAT Gateway e sem internet gateway.
# A Lambda fala com a AWS só por VPC endpoints:
# - DynamoDB por gateway endpoint (sem custo);
# - Bedrock Runtime e CloudWatch Logs por interface endpoints (cobrados por hora e por AZ).

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = local.name })
}

# Tira todas as regras do security group padrão, para nada usá-lo por engano.
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${local.name}-default-bloqueado" })
}

resource "aws_subnet" "private" {
  count = var.az_count

  vpc_id            = aws_vpc.this.id
  cidr_block        = local.private_cidrs[count.index]
  availability_zone = local.azs[count.index]
  tags              = merge(var.tags, { Name = "${local.name}-privada-${local.azs[count.index]}" })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${local.name}-privada" })
}

resource "aws_route_table_association" "private" {
  count = var.az_count

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# ---------------- security groups ----------------
resource "aws_security_group" "app" {
  name        = "${local.name}-app"
  description = "Funcoes Lambda da aplicacao: so saida HTTPS"
  vpc_id      = aws_vpc.this.id
  tags        = merge(var.tags, { Name = "${local.name}-app" })
}

# Sem internet gateway nem NAT, a saída só alcança os endpoints da VPC.
resource "aws_vpc_security_group_egress_rule" "app_https" {
  security_group_id = aws_security_group.app.id
  description       = "HTTPS para os VPC endpoints"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "endpoints" {
  count = length(var.interface_endpoint_services) > 0 ? 1 : 0

  name        = "${local.name}-endpoints"
  description = "Interface endpoints: HTTPS vindo das funcoes da aplicacao"
  vpc_id      = aws_vpc.this.id
  tags        = merge(var.tags, { Name = "${local.name}-endpoints" })
}

resource "aws_vpc_security_group_ingress_rule" "endpoints_from_app" {
  count = length(var.interface_endpoint_services) > 0 ? 1 : 0

  security_group_id            = aws_security_group.endpoints[0].id
  description                  = "HTTPS das funcoes da aplicacao"
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  referenced_security_group_id = aws_security_group.app.id
}

# ---------------- endpoints ----------------
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]
  tags              = merge(var.tags, { Name = "${local.name}-dynamodb" })
}

resource "aws_vpc_endpoint" "interface" {
  for_each = toset(var.interface_endpoint_services)

  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.${each.value}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.endpoints[0].id]
  tags                = merge(var.tags, { Name = "${local.name}-${each.value}" })
}
