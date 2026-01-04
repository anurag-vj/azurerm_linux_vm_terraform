output "public_ip" {
  value = azurerm_public_ip.public-ip[0].ip_address
}
