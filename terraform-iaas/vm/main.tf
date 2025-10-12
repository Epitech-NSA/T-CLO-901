variable "rg_name" {
  type        = string
}

variable "rg_location" {
  type        = string
}

variable "subnet_id" {
  type        = string
}

resource "azurerm_public_ip" "vm_app_ip" {
  name                = "vm-app-ip"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "vm_traefik_ip" {
  name                = "vm-traefik-ip"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "vm_db_ip" {
  name                = "vm-db-ip"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "vm_app_nic" {
  name                = "vm-app-nic"
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_app_ip.id
  }
}

resource "azurerm_network_interface" "vm_traefik_nic" {
  name                = "vm-traefik-nic"
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_traefik_ip.id
  }
}

resource "azurerm_network_interface" "vm_db_nic" {
  name                = "vm-db-nic"
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_db_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm_app" {
  name                = "vm-app"
  location            = var.rg_location
  resource_group_name = var.rg_name
  network_interface_ids = [azurerm_network_interface.vm_app_nic.id]
  size                = var.vm_size
  admin_username      = var.vm_admin_username

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file(var.ssh_public_key_path)
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_linux_virtual_machine" "vm_traefik" {
  name                = "vm-traefik"
  location            = var.rg_location
  resource_group_name = var.rg_name
  network_interface_ids = [azurerm_network_interface.vm_traefik_nic.id]
  size                = var.vm_size
  admin_username      = var.vm_admin_username

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file(var.ssh_public_key_path)
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_linux_virtual_machine" "vm_db" {
  name                = "vm-db"
  location            = var.rg_location
  resource_group_name = var.rg_name
  network_interface_ids = [azurerm_network_interface.vm_db_nic.id]
  size                = var.vm_size
  admin_username      = var.vm_admin_username

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file(var.ssh_public_key_path)
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}