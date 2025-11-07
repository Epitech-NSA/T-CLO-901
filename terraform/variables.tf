variable "rg_name" {
  type        = string
  default     = "rg-nan_1"
}

variable "rg_location" {
  type        = string
  default     = "francecentral"
}

variable "rg_tags" {
  type = map(string)
  default = {
    env            = "dev"
    owner          = "etu-epitech"
    project        = "TERRACLOUD"
    shutdownPolicy = "19:00-08:00"
    subscription   = "6b9318b1-2215-418a-b0fd-ba0832e9b333"
  }
}

variable "storage" {
  type = map(string)
  default = {
    name = "sttcdevfrc01"
    account_tier = "Standard"
    account_replication_type = "LRS"
    min_tls = "TLS1_0"
  }
}

variable "storage_allow_nested_items_to_be_public" {
  type = bool
  default = false
}

variable "vnet" {
  type = map(string)
  default = {
    name = "vnet"
    address_space = "10.0.0.0/16"
  }
}

variable "app_subnet" {
  type = map(string)
  default = {
    name = "app-subnet"
    address_prefixes = "10.0.2.0/24"
  }
}

variable "mysql_subnet" {
  type = map(string)
  default = {
    name = "mysql-subnet"
    address_prefixes = "10.0.1.0/24"
  }
}

variable "database_login" {
  type = string
  default = "identifiant"
}

variable "database_password" {
  type = string
  default = "ChangeMoi"
}