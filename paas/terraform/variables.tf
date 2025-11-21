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

variable "vnet" {
  type = map(string)
  default = {
    name = "tc-vnet-paas-frc-01"
    address_space = "10.0.0.0/16"
  }
}

variable "app_subnet" {
  type = map(string)
  default = {
    name = "tc-snet-paas-app-frc-01"
    address_prefixes = "10.0.2.0/24"
  }
}

variable "mysql_subnet" {
  type = map(string)
  default = {
    name = "tc-snet-paas-db-frc-01"
    address_prefixes = "10.0.1.0/24"
  }
}

variable "database_login" {
  type = string
}

variable "database_password" {
  type = string
}

variable "acr_name" {
  type    = string
}