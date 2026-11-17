locals {
  name        = "${var.basename}-${var.environment}-${var.site_name}"
  bucket_name = "${local.name}-${data.aws_caller_identity.current.account_id}"
  aliases     = concat([var.domain_name], var.redirect_www ? ["www.${var.domain_name}"] : [])
}
