# Refer to resource group
data "azurerm_resource_group" "RG" {
    name ="TerrformRG"
}

# Refer to Virtual Network
data "azurerm_virtual_network" "Vnet1" {
    name ="Terrform-Vnet1"
    resource_group_name = "${data.azurerm_resource_group.RG.name}"
}
# Refer to Subnet X0
data "azurerm_subnet" "X0_subnet" {
    name = "X0"
    virtual_network_name = "${data.azurerm_virtual_network.Vnet1.name}"
    resource_group_name = "${data.azurerm_resource_group.RG.name}"
}

# Create network interface for VM
resource "azurerm_network_interface" "NIC-VM" {
  name                = var.NIC_Name
  location            = "${data.azurerm_resource_group.RG.location}"
  resource_group_name = "${data.azurerm_resource_group.RG.name}"

  ip_configuration {
    name                                               = "internal"
    subnet_id                                          = "${data.azurerm_subnet.X0_subnet.id}"
    private_ip_address_allocation                      = "Dynamic"
       
  }
}

# Create Virtual Machine SQL
resource "azurerm_windows_virtual_machine" "Sqlvm" {
  name                  	= var.VM_Name
  location              	= "${data.azurerm_resource_group.RG.location}"
  resource_group_name   	= "${data.azurerm_resource_group.RG.name}"
  network_interface_ids 	= [azurerm_network_interface.NIC-VM.id]
  size               		= "Standard_DS2_v2"
  admin_username        	= var.username
  admin_password        	= var.admin_password
    os_disk {
    name                             = "SQL-OS"
    caching                          = "ReadWrite"
    disk_size_gb                     = 127
    storage_account_type              = "Standard_LRS"
    write_accelerator_enabled        = false
  }
  source_image_reference {
	publisher = "MicrosoftSQLServer"
	offer     = "SQL2019-WS2022"
	sku       = "Developer"
	version   = "latest"
}
  }
  #  The SQL Server IaaS Agent Extension
resource "azurerm_mssql_virtual_machine" "sql_extension"  {
  virtual_machine_id         = azurerm_windows_virtual_machine.Sqlvm.id
  sql_license_type   		= "PAYG"
  auto_patching {
	day_of_week                   		 	= "Sunday"
	maintenance_window_starting_hour 	 	= 2
	maintenance_window_duration_in_minutes	= 60
}
}

  
