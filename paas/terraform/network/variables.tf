variable "rg_name" {
  type        = string
  description = "The name of the resource group."
}

variable "rg_location" {
  type        = string
  description = "The location of the resource group."
}

variable "vnet" {
  type = map(string)
}

variable "app_subnet" {
  type = map(string)
}

variable "mysql_subnet" {
  type = map(string)
}
