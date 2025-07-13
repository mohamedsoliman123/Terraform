# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-resilient-vms-tutorial"
  location = "East US 2"
}
#create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-resilient"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "snet-internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
# Create Netwrok Interfaces
resource "azurerm_network_interface" "nic" {
  count               = 3
  name                = "nic-vm-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Create Virtual Machines Availability Zone
resource "azurerm_linux_virtual_machine" "vm" {
  count                           = 3
  name                            = "resilient-vm-${count.index + 1}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B1s"
  admin_username                  = "azureadmin"
  admin_password                  = "Password12345!" # WARNING: Never do this in production! Use SSH keys or Key Vault.
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic[count.index].id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  zone = count.index + 1
}
