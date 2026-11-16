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
  https_only              = true

  site_config {
    cors {
      allowed_origins = [
        "https://portal.azure.com",
        "https://${var.domain}"
      ]
    }
  }

  app_settings = {
    connection_key = azurerm_cosmosdb_account.db_account.primary_sql_connection_string
  }
}