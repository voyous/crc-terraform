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

variable "website_rg_name" {
  description = "Website resource group name"
  type        = string
  default     = "crc-resume-website"
}

variable "website_sa_name" {
  description = "Storage account name"
  type        = string
  default     = "crcwebsitesa01"
}
