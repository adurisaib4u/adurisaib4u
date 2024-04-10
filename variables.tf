variable "location" {
  description = "Azure region where resources will be deployed"
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  default     = "acme-ecommerce-rg"
}

variable "app_service_tier" {
  description = "Tier of Azure App Services"
  default     = "Standard" 
}

variable "sql_sku" {
  description = "SKU for the Azure SQL Database"
  default     = "Standard" 
}

variable "sql_server_name" {
  description = "Name of the SQL Server"
  default     = "veripark-acme-sql-server"
}

variable "sql_database_name" {
  description = "Name of the Azure SQL Database"
  default     = "veripark-acme-sql-db"
}

variable "sql_admin_username" {
  description = "Admin username for the SQL Server"
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "Admin password for the SQL Server"
  default     = "Acme@12345" 
}