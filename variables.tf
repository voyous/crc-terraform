# Variables

variable "zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  sensitive   = true
}

variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "Domain name"
  type        = string
  default     = "example.com"
}

variable "location" {
  description = "Azure region value"
  type        = string
  default     = "West US"
}

variable "website_rg_name" {
  description = "Website resource group name"
  type        = string
  default     = ""
}

variable "website_sa_name" {
  description = "Storage account name"
  type        = string
  default     = ""
}

variable "api_rg_name" {
  description = "API resource group name"
  type        = string
  default     = ""
}

variable "api_sa_name" {
  description = "API storage account name"
  type        = string
  default     = ""
}

variable "api_sc_name" {
  description = "API storage container name"
  type        = string
  default     = ""
}

variable "api_asp_name" {
  description = "API app service plan name"
  type        = string
  default     = ""
}

variable "api_fa_name" {
  description = "API function app name"
  type        = string
  default     = ""
}

variable "db_account_name" {
  description = "DB account name"
  type        = string
  default     = ""
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = ""
}

variable "db_container_name" {
  description = "Database container name"
  type        = string
  default     = ""
}