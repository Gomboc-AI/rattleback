# Resource group: /subscriptions/aaaa-bbbb/resourceGroups/rg-prod-network
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# VNet: /subscriptions/aaaa-bbbb/resourceGroups/rg-prod-network/providers/Microsoft.Network/virtualNetworks/vnet-prod
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # Subnet: /subscriptions/aaaa-bbbb/resourceGroups/rg-prod-network/providers/Microsoft.Network/virtualNetworks/vnet-prod/subnets/snet-app-tier
  subnet {
    name             = "snet-app-tier"
    address_prefixes = ["10.0.1.0/24"]
  }

  # Subnet: /subscriptions/aaaa-bbbb/resourceGroups/rg-prod-network/providers/Microsoft.Network/virtualNetworks/vnet-prod/subnets/snet-db-tier
  subnet {
    name             = "snet-db-tier"
    address_prefixes = ["10.0.2.0/24"]
  }
}

# NSG: /subscriptions/aaaa-bbbb/resourceGroups/rg-prod-network/providers/Microsoft.Network/networkSecurityGroups/nsg-app-tier-default
resource "azurerm_network_security_group" "app_tier" {
  name                = "nsg-app-tier-default"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "app_vm" {
  name                = "nic-app-vm-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_virtual_network.main.subnet.*.id[0]
    private_ip_address_allocation = "Dynamic"
  }
}

# VM: /subscriptions/aaaa-bbbb/resourceGroups/rg-prod-network/providers/Microsoft.Compute/virtualMachines/vm-app-01
resource "azurerm_virtual_machine" "app" {
  name                  = "vm-app-01"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.app_vm.id]
  vm_size               = "Standard_D2s_v3"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk-app-vm-01"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "vm-app-01"
    admin_username = "azureadmin"
    admin_password = "P@ssw0rd1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}

# NSG: /subscriptions/aaaa-bbbb/resourceGroups/rg-prod-network/providers/Microsoft.Network/networkSecurityGroups/nsg-db-tier-default
resource "azurerm_network_security_group" "db_tier" {
  name                = "nsg-db-tier-default"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowSQL"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }
}

# Association: nsg-db-tier-default <-> snet-db-tier
resource "azurerm_subnet_network_security_group_association" "db_tier" {
  subnet_id                 = azurerm_virtual_network.main.subnet.*.id[1]
  network_security_group_id = azurerm_network_security_group.db_tier.id
}
