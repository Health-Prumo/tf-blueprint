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

variable "table_name" {
  description = "Nome curto da tabela, usado no nome final (ex.: dados)."
  type        = string
  default     = "dados"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,30}$", var.table_name))
    error_message = "Use só letras minúsculas, números e hífen (2 a 31 caracteres)."
  }
}

variable "ttl_attribute" {
  description = "Atributo com o instante (epoch em segundos) em que o item expira. Vazio desliga o TTL."
  type        = string
  default     = "expira_em"
}

variable "point_in_time_recovery" {
  description = "Liga o backup contínuo (PITR), cobrado por GB armazenado."
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Impede apagar a tabela por engano (inclusive pelo terraform destroy)."
  type        = bool
  default     = true
}
