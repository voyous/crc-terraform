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