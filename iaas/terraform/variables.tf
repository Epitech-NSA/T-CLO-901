variable "rg_name" {
  type        = string
}

variable "rg_location" {
  type        = string
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

variable "acr_name" {
  type        = string
}

variable "database_login" {
  type = string
  default = "identifiant"
}

variable "database_password" {
  type = string
  sensitive = true
}

variable "subnet" {
  type = map(string)
  default = {
    name           = "tc-snet-iaas-frc-01"
    address_prefix = "10.0.1.0/24"
  }
}