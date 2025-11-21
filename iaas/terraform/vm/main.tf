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
  name                = "tc-pip-app-frc-01"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vm_app_nic" {
  name                = "tc-nic-app-frc-01"
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_app_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm_app" {
  name                = "tc-vm-app-frc-01"
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
    publisher = "Debian"
    offer     = "debian-11"
    sku       = "11-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}