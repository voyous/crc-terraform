# Database settings

resource "azurerm_cosmosdb_account" "db_account" {
  name                = var.db_account_name
  location            = var.location
  resource_group_name = azurerm_resource_group.api_rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  automatic_failover_enabled = true

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }
}

resource "azurerm_cosmosdb_sql_database" "db_main" {
  name                = var.db_name
  resource_group_name = azurerm_resource_group.api_rg.name
  account_name        = azurerm_cosmosdb_account.db_account.name
}

resource "azurerm_cosmosdb_sql_container" "db_container" {
  name                = var.db_container_name
  resource_group_name = azurerm_resource_group.api_rg.name
  account_name        = azurerm_cosmosdb_account.db_account.name
  database_name       = azurerm_cosmosdb_sql_database.db_main.name

  partition_key_paths   = ["/id"]
  partition_key_version = 2

  conflict_resolution_policy {
    conflict_resolution_path = "/_ts"
    mode                     = "LastWriterWins"
  }

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }
  }
}