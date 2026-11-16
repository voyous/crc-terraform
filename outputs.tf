output "domain" {
  description = "Domain name"
  value       = var.domain
}


# Front-end outputs

output "website_sa_endpoint" {
  description = "Website storage account endpoint"
  value       = azurerm_storage_account.storage.primary_web_host
}

output "storage_account_id" {
  description = "Website storage account ID"
  value       = azurerm_storage_account.storage.id
}

output "website_rg_name" {
  description = "Website resource group name"
  value       = azurerm_resource_group.website.name
}


# API outputs

output "api_rg_name" {
  description = "API resource group name"
  value       = azurerm_resource_group.api_rg.name
}


# Database outputs

output "database_account_name" {
  description = "Database account name"
  value       = azurerm_cosmosdb_account.db_account.name
}

output "database_name" {
  description = "Database name"
  value       = azurerm_cosmosdb_sql_database.db_main.name
}

output "database_container_name" {
  description = "Database container name"
  value       = azurerm_cosmosdb_sql_container.db_container.name
}