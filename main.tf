# Azure provider
provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# App Service Plan
resource "azurerm_service_plan" "app_service_plan" {
  name                = "acme-appservice-plan"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "App"
  sku {
    tier = var.app_service_tier
    size = "S1"
  }
}

# Web API Application (Backend for frontend)
resource "azurerm_app_service" "app_service_bff" {
  name                = "acme-bff-appservice"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_service_plan.app_service_plan.id
}

# Web API Application (Middleware)
resource "azurerm_app_service" "app_service_middleware" {
  name                = "acme-middleware-appservice"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_service_plan.app_service_plan.id
}

# Application Database (Azure SQL Database)
resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "sql_db" {
  name                = var.sql_database_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  server_id           = azurerm_mssql_server.sql_server.id
  edition             = var.sql_sku
  collation           = "SQL_Latin1_General_CP1_CI_AS"
}

# Associate private DNS zone with private endpoint
resource "azurerm_private_dns_zone_virtual_network_link" "sql_dns_link" {
  name                  = "sql-dns-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.sql_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

# DNS settings for private endpoint
resource "azurerm_private_dns_zone" "sql_dns_zone" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

# Virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "acme-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
}

# Subnet for private endpoint
resource "azurerm_subnet" "subnet" {
  name                 = "private-endpoint-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
