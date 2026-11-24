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

variable "cidr_block" {
  description = "Faixa de IPs da VPC."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.cidr_block)) && tonumber(split("/", var.cidr_block)[1]) <= 20
    error_message = "Informe um CIDR IPv4 válido de /16 a /20."
  }
}

variable "az_count" {
  description = "Quantidade de zonas de disponibilidade com subnet privada."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "Use 2 ou 3 zonas de disponibilidade."
  }
}

variable "interface_endpoint_services" {
  description = "Serviços com interface endpoint (cobrados por hora e por AZ). Lista vazia desliga todos."
  type        = list(string)
  default     = ["bedrock-runtime", "logs"]

  validation {
    condition     = alltrue([for s in var.interface_endpoint_services : can(regex("^[a-z0-9.-]+$", s))])
    error_message = "Use o nome curto do serviço, por exemplo bedrock-runtime ou logs."
  }
}
