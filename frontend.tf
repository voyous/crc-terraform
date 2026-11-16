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
      custom_domain,
      public_network_access
    ]
  }
}

resource "azurerm_storage_container" "container" {
  name                  = "$web"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}

resource "time_sleep" "wait_for_dns" {
  depends_on = [cloudflare_dns_record.asverify]

  create_duration = "45s"
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
    time_sleep.wait_for_dns
  ]

  lifecycle {
    ignore_changes = [
      body
    ]
  }
}

resource "azurerm_storage_account_static_website" "static_website" {
  storage_account_id = azurerm_storage_account.storage.id
  index_document = "index.html"
}