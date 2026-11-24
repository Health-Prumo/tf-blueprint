variable "basename" {
  description = "Prefixo dos nomes dos recursos (nome do projeto)."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,20}$", var.basename))
    error_message = "Use só letras minúsculas, números e hífen (2 a 21 caracteres)."
  }
}

variable "environment" {
  description = "Ambiente (dev, hml, prod ou global)."
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

variable "app_name" {
  description = "Nome do produto exibido nos e-mails do Cognito."
  type        = string
  default     = "Prumo"
}

variable "deletion_protection" {
  description = "Impede apagar o user pool por engano."
  type        = bool
  default     = true
}

variable "id_token_validity_minutes" {
  description = "Validade do ID token e do access token, em minutos."
  type        = number
  default     = 60

  validation {
    condition     = var.id_token_validity_minutes >= 5 && var.id_token_validity_minutes <= 1440
    error_message = "Use de 5 a 1440 minutos."
  }
}

variable "refresh_token_validity_days" {
  description = "Validade do refresh token, em dias."
  type        = number
  default     = 30

  validation {
    condition     = var.refresh_token_validity_days >= 1 && var.refresh_token_validity_days <= 3650
    error_message = "Use de 1 a 3650 dias."
  }
}
