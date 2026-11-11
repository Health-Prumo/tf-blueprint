variable "basename" {
  description = "Prefixo dos nomes dos recursos (nome do projeto)."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,20}$", var.basename))
    error_message = "Use só letras minúsculas, números e hífen (2 a 21 caracteres)."
  }
}

variable "environment" {
  description = "Ambiente (dev, hml ou prod)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prod", "global"], var.environment)
    error_message = "O ambiente deve ser dev, hml, prod ou global."
  }
}

variable "tags" {
  description = "Tags extras aplicadas aos recursos do módulo."
  type        = map(string)
  default     = {}
}

variable "monthly_limit_usd" {
  description = "Limite mensal em USD. Também é a base do alerta de previsão."
  type        = number

  validation {
    condition     = var.monthly_limit_usd > 0
    error_message = "O limite precisa ser maior que zero."
  }
}

variable "alert_thresholds_usd" {
  description = "Valores em USD de gasto real que disparam e-mail."
  type        = list(number)
  default     = [20, 40]
}

variable "alert_emails" {
  description = "E-mails que recebem os alertas."
  type        = list(string)

  validation {
    condition     = length(var.alert_emails) > 0 && alltrue([for e in var.alert_emails : can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", e))])
    error_message = "Informe ao menos um e-mail válido."
  }
}
