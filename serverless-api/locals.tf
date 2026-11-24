locals {
  name          = "${var.basename}-${var.environment}-${var.api_name}"
  custom_domain = var.domain_name != ""
}
