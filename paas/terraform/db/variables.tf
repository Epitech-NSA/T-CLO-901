variable "rg_name" {
  type        = string
  description = "The name of the resource group."
}

variable "rg_location" {
  type        = string
  description = "The location of the resource group."
}

variable "database_login" {
  type = string
}

variable "database_password" {
  type = string
  sensitive = true
}
