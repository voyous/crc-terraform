# Set up providers

terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=5.0.0"
        }

        azapi = {
            source = "Azure/azapi"
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

provider "azapi" {
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


# Website storage account and container settings

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

resource "azapi_update_resource" "custom_domain" {
    type      = "Microsoft.Storage/storageAccounts@2021-09-01"
    resource_id = azurerm_storage_account.storage.id

    body = {
        properties = {
            customDomain = {
                name = var.domain
                useSubDomainName = true
            }
        }
    }

    depends_on = [
        cloudflare_dns_record.asverify
    ]

    lifecycle {
        ignore_changes = [
            body
        ]
    }
}


# Cloudflare DNS settings

resource "cloudflare_dns_record" "asverify" {
    zone_id = var.zone_id
    name = "asverify.${var.domain}"
    content = "asverify.${azurerm_storage_account.storage.primary_web_host}"
    type = "CNAME"
    ttl = 1
    proxied = false
    comment = "azverify CNAME record for custom domain on storage account"
}

resource "cloudflare_dns_record" "domain" {
    zone_id = var.zone_id
    name = var.domain
    content = azurerm_storage_account.storage.primary_web_host
    type = "CNAME"
    ttl = 1
    proxied = true
    comment = "CNAME record for azure storage account endpoint"
}