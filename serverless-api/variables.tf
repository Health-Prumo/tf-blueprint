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

variable "api_name" {
  description = "Nome curto da API, usado no nome da função e da API (ex.: api)."
  type        = string
  default     = "api"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,15}$", var.api_name))
    error_message = "Use só letras minúsculas, números e hífen (2 a 16 caracteres)."
  }
}

variable "handler" {
  description = "Função de entrada da Lambda (módulo.função)."
  type        = string
}

variable "runtime" {
  description = "Runtime da Lambda."
  type        = string
  default     = "python3.12"
}

variable "memory_size" {
  description = "Memória da Lambda em MB."
  type        = number
  default     = 256

  validation {
    condition     = var.memory_size >= 128 && var.memory_size <= 3008
    error_message = "Use de 128 a 3008 MB."
  }
}

variable "timeout" {
  description = "Tempo máximo da Lambda em segundos (o HTTP API corta em 30)."
  type        = number
  default     = 20

  validation {
    condition     = var.timeout >= 1 && var.timeout <= 29
    error_message = "Use de 1 a 29 segundos."
  }
}

variable "environment_variables" {
  description = "Variáveis de ambiente da Lambda. Não coloque segredos aqui (ficam no estado)."
  type        = map(string)
  default     = {}
}

variable "subnet_ids" {
  description = "Subnets privadas onde a Lambda roda."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "Informe ao menos 2 subnets (2 AZs)."
  }
}

variable "security_group_ids" {
  description = "Security groups da Lambda."
  type        = list(string)
}

variable "dynamodb_table_arns" {
  description = "Tabelas do DynamoDB que a Lambda lê e escreve."
  type        = list(string)
  default     = []
}

variable "bedrock_model_ids" {
  description = "Modelos do Bedrock que a Lambda pode invocar (ex.: amazon.nova-micro-v1:0)."
  type        = list(string)
  default     = []
}

variable "log_retention_days" {
  description = "Retenção dos logs no CloudWatch, em dias."
  type        = number
  default     = 14
}

variable "jwt_issuer" {
  description = "Emissor dos tokens JWT (URL do user pool do Cognito)."
  type        = string

  validation {
    condition     = startswith(var.jwt_issuer, "https://")
    error_message = "O emissor deve ser uma URL https."
  }
}

variable "jwt_audience" {
  description = "Audiências aceitas no JWT (client id do Cognito)."
  type        = list(string)
}

variable "public_routes" {
  description = "Rotas sem autenticação, no formato \"MÉTODO /caminho\"."
  type        = list(string)
  default     = ["GET /saude"]
}

variable "cors_allow_origins" {
  description = "Origens aceitas pelo CORS (ex.: https://app.exemplo.com)."
  type        = list(string)
}

variable "throttling_burst_limit" {
  description = "Pico de requisições aceitas pela API (proteção de custo)."
  type        = number
  default     = 20
}

variable "throttling_rate_limit" {
  description = "Requisições por segundo aceitas pela API (proteção de custo)."
  type        = number
  default     = 10
}

variable "domain_name" {
  description = "Domínio próprio da API (ex.: api.exemplo.com). Vazio usa só o endereço padrão."
  type        = string
  default     = ""
}

variable "zone_id" {
  description = "Hosted zone do Route 53 do domínio próprio. Obrigatória com domain_name."
  type        = string
  default     = ""
}
