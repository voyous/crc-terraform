# Website storage account and container settings

resource "azurerm_resource_group" "website" {
  name     = var.website_rg_name
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name                     = var.website_sa_name
  resource_group_name      = azurerm_resource_group.website.name
  location                 = var.location
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
  type        = "Microsoft.Storage/storageAccounts@2021-09-01"
  resource_id = azurerm_storage_account.storage.id

  body = {
    properties = {
      customDomain = {
        name             = var.domain
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
  name    = "asverify.${var.domain}"
  content = "asverify.${azurerm_storage_account.storage.primary_web_host}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
  comment = "azverify CNAME record for custom domain on storage account"
}

resource "cloudflare_dns_record" "domain" {
  zone_id = var.zone_id
  name    = var.domain
  content = azurerm_storage_account.storage.primary_web_host
  type    = "CNAME"
  ttl     = 1
  proxied = true
  comment = "CNAME record for azure storage account endpoint"
}


# Backend API settings

resource "azurerm_resource_group" "api_rg" {
  name     = var.api_rg_name
  location = var.location
}

resource "azurerm_storage_account" "api_sa" {
  name                     = var.api_sa_name
  resource_group_name      = azurerm_resource_group.api_rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  default_to_oauth_authentication = true
}

resource "azurerm_storage_container" "api_sc" {
  name                  = var.api_sc_name
  storage_account_id    = azurerm_storage_account.api_sa.id
  container_access_type = "private"
}

resource "azurerm_service_plan" "api_asp" {
  name                = var.api_asp_name
  resource_group_name = azurerm_resource_group.api_rg.name
  location            = var.location
  sku_name            = "FC1"
  os_type             = "Linux"
}

resource "azurerm_function_app_flex_consumption" "api_fa" {
  name                = var.api_fa_name
  resource_group_name = azurerm_resource_group.api_rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.api_asp.id

  storage_container_type      = "blobContainer"
  storage_container_endpoint  = "${azurerm_storage_account.api_sa.primary_blob_endpoint}${azurerm_storage_container.api_sc.name}"
  storage_authentication_type = "StorageAccountConnectionString"
  storage_access_key          = azurerm_storage_account.api_sa.primary_access_key
  runtime_name                = "python"
  runtime_version             = "3.12"
  maximum_instance_count      = 100
  instance_memory_in_mb       = 2048

  client_certificate_mode = "Required"
  https_only = true

  site_config {
    cors {
      allowed_origins = [
        "https://portal.azure.com",
        "https://${var.domain}"
      ]
    }
  }
}