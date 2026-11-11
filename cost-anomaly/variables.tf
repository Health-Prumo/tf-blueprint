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

variable "impact_threshold_usd" {
  description = "Impacto mínimo da anomalia, em USD, para enviar o e-mail."
  type        = number
  default     = 5

  validation {
    condition     = var.impact_threshold_usd > 0
    error_message = "O valor precisa ser maior que zero."
  }
}

variable "frequency" {
  description = "Frequência do e-mail. DAILY ou WEEKLY (IMMEDIATE exige SNS e não é suportado aqui)."
  type        = string
  default     = "DAILY"

  validation {
    condition     = contains(["DAILY", "WEEKLY"], var.frequency)
    error_message = "Use DAILY ou WEEKLY."
  }
}

variable "alert_emails" {
  description = "E-mails que recebem os alertas de anomalia (máximo de 10)."
  type        = list(string)

  validation {
    condition     = length(var.alert_emails) > 0 && length(var.alert_emails) <= 10 && alltrue([for e in var.alert_emails : can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", e))])
    error_message = "Informe de 1 a 10 e-mails válidos."
  }
}
