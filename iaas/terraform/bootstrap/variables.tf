variable "rg_name" {
  type        = string
}

variable "rg_location" {
  type        = string
}

variable "acr_name" {
  type        = string
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