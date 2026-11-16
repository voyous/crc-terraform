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