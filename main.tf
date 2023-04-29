# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Generate random passwords for each VM
resource "random_password" "admin_password" {
  length           = 16
  special          = true
  override_special = "_@%"
  numeric           = true
}

# Create resource group
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

# Create virtual network
resource "azurerm_virtual_network" "virtual_network" {
  name                = var.virtual_network_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create virtual machines
resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "my-vm-${count.index}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  size                = var.vm_size
  admin_username      = "adminuser"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  admin_password = random_password.admin_password.result

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  computer_name = "myvm${count.index}"
}

# Execute the ping commands on the VMs
resource "azurerm_virtual_machine_extension" "vm_extension" {
  count                      = var.vm_count
  name                       = "my-vm-extension-${count.index}"
  virtual_machine_id         = "${azurerm_linux_virtual_machine.vm[count.index].id}"
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.0"

  settings = jsonencode({
    commandToExecute = <<EOF
    #!/bin/bash
    destination=$(((${count.index} + 1) % ${var.vm_count}))
    ping -c 1 my-vm-$${destination}.my-vm-vnet.southcentralus.cloudapp.azure.com >/dev/null 2>&1
    if [[ $$? -eq 0 ]]; then
      echo "Ping from my-vm-${count.index} to my-vm-$${destination} succeeded" >> /pingoutput.txt
    else
      echo "Ping from my-vm-${count.index} to my-vm-$${destination} failed" >> /pingoutput.txt
    fi
    EOF
  })
}

# Create network interfaces
resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "my-nic-${count.index}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location

  ip_configuration {
    name                          = "my-nic-ipconfig-${count.index}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Output the custom script extension output
# output "custom_script_output" {
#   value = {
#     for vm_extension in azurerm_virtual_machine_extension.vm_extension : vm_extension => vm_extension[count.index].settings["commandToExecute"]
#   }
# }
