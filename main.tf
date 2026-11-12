# Set up providers

terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=5.0.0"
        }

        cloudflare = {
            source  = "cloudflare/cloudflare"
            version = "~> 5"
        }
    }
}

provider "azurerm" {
    features {}
}

provider "cloudflare" {
    # API Token to be read from environment variable
}


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


# Storage account setup

resource "azurerm_resource_group" "website" {
    name     = var.website_rg_name
    location = "Australia East"
}

resource "azurerm_storage_account" "storage" {
    name                     = var.website_sa_name
    resource_group_name      = azurerm_resource_group.website.name
    location                 = azurerm_resource_group.website.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    custom_domain {
        name          = var.domain
        use_subdomain = true
    }

    lifecycle {
        ignore_changes = [
            custom_domain
        ]
    }
}

resource "azurerm_storage_container" "container" {
    name                  = "$web"
    storage_account_id    = azurerm_storage_account.storage.id
    container_access_type = "private"
}