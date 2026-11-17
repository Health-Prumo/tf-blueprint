# Zona pública do domínio. O registro do domínio continua na registradora (GoDaddy):
# lá só se trocam os nameservers pelos que esta zona devolve em `name_servers`.
resource "aws_route53_zone" "this" {
  name          = var.domain_name
  comment       = "${local.name}-dns: zona pública de ${var.domain_name}"
  force_destroy = false
  tags          = var.tags
}

# O domínio não envia nem recebe e-mail. Estes três registros dizem isso ao mundo e
# impedem que alguém mande e-mail falso em nome dele (spoofing).
# Desligue com block_email = false quando o domínio passar a usar e-mail.

# SPF: nenhum servidor pode enviar e-mail por este domínio.
# Outros TXT da raiz (verificação de serviços, por exemplo) entram em apex_txt_records,
# porque a raiz só aceita um conjunto de registros TXT.
resource "aws_route53_record" "apex_txt" {
  count = var.block_email || length(var.apex_txt_records) > 0 ? 1 : 0

  zone_id = aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "TXT"
  ttl     = 3600
  records = concat(var.block_email ? ["v=spf1 -all"] : [], var.apex_txt_records)
}

# DMARC: rejeita qualquer e-mail que diga vir deste domínio.
resource "aws_route53_record" "dmarc" {
  count = var.block_email ? 1 : 0

  zone_id = aws_route53_zone.this.zone_id
  name    = "_dmarc.${var.domain_name}"
  type    = "TXT"
  ttl     = 3600
  records = ["v=DMARC1; p=reject; adkim=s; aspf=s"]
}

# MX nulo (RFC 7505): o domínio não recebe e-mail.
resource "aws_route53_record" "null_mx" {
  count = var.block_email ? 1 : 0

  zone_id = aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "MX"
  ttl     = 3600
  records = ["0 ."]
}
