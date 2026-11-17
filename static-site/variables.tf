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

variable "site_name" {
  description = "Nome curto do site, usado nos nomes dos recursos (ex.: landing, app)."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,15}$", var.site_name))
    error_message = "Use só letras minúsculas, números e hífen (2 a 16 caracteres)."
  }
}

variable "domain_name" {
  description = "Endereço principal do site, sem ponto no final (ex.: exemplo.com.br)."
  type        = string

  validation {
    condition     = can(regex("^([a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\\.)+[a-z]{2,}$", var.domain_name))
    error_message = "Informe um domínio válido em minúsculas, sem ponto no final."
  }
}

variable "zone_id" {
  description = "ID da hosted zone do Route 53 onde ficam o alias e a validação do certificado."
  type        = string

  validation {
    condition     = can(regex("^Z[A-Z0-9]{5,31}$", var.zone_id))
    error_message = "Informe o ID de uma hosted zone do Route 53 (começa com Z)."
  }
}

variable "redirect_www" {
  description = "Também atende www.<domínio>, com redirecionamento 301 para o domínio principal."
  type        = bool
  default     = true
}

variable "price_class" {
  description = "Classe de preço do CloudFront. PriceClass_All inclui a borda de São Paulo."
  type        = string
  default     = "PriceClass_All"

  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "Use PriceClass_All, PriceClass_200 ou PriceClass_100."
  }
}

variable "force_destroy" {
  description = "Permite apagar o bucket mesmo com arquivos dentro."
  type        = bool
  default     = false
}
