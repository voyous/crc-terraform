terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=5.0.0"
        }
    }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "website" {
    name     = "crc-resume-website"
    location = "Australia East"
}

resource "azurerm_storage_account" "storage" {
    name                     = "crcwebsitesa01"
    resource_group_name      = azurerm_resource_group.website.name
    location                 = azurerm_resource_group.website.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    custom_domain {
        name = "resume.voyous.dev"
        use_subdomain = true
    }

    lifecycle {
        ignore_changes = [
            custom_domain
        ]
    }
}

resource "azurerm_storage_container" "container" {
    name = "$web"
    storage_account_id = azurerm_storage_account.storage.id
    container_access_type = "private"
}