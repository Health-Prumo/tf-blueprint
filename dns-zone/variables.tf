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
  description = "Tags extras aplicadas à zona (registros DNS não aceitam tags)."
  type        = map(string)
  default     = {}
}

variable "domain_name" {
  description = "Domínio da zona, sem ponto no final (ex.: exemplo.com.br)."
  type        = string

  validation {
    condition     = can(regex("^([a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\\.)+[a-z]{2,}$", var.domain_name))
    error_message = "Informe um domínio válido em minúsculas, sem ponto no final."
  }
}

variable "block_email" {
  description = "Cria SPF -all, DMARC p=reject e MX nulo, para um domínio que não usa e-mail."
  type        = bool
  default     = true
}

variable "apex_txt_records" {
  description = "TXT extras na raiz do domínio (ex.: verificação de serviços). Cada item é um valor."
  type        = list(string)
  default     = []
}
