output "domain" {
  description = "Domain name"
  value       = var.domain
}

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