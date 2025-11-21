variable "rg_name" {
  type        = string
  description = "The name of the resource group."
}

variable "rg_location" {
  type        = string
  description = "The location of the resource group."
}

variable "acr_login_server" {
  type = string
}

variable "acr_admin_username" {
  type = string
}

variable "acr_admin_password" {
  type = string
  sensitive = true
}

variable "db_fqdn" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_administrator_login" {
  type = string
}

variable "db_administrator_password" {
  type = string
  sensitive = true
}

variable "db_server_name" {
  type = string
}
