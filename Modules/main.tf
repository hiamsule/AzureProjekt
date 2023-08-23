terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.69.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Teqwerk cloud-config configuration file.
  part {
    content_type = "text/cloud-config"
    content      = "packages: ['nginx']"
  }
}

resource "azurerm_resource_group" "Teqwerk" {
  name     = "${var.stage}-resource-group"
  location = "West Europe"
}

resource "azurerm_virtual_network" "Teqwerk" {
  name                = "${var.stage}-virtual-network"
  address_space       = ["${var.network_cidr}"]
  location            = azurerm_resource_group.Teqwerk.location
  resource_group_name = azurerm_resource_group.Teqwerk.name

  tags = {
    environment = "${var.stage}"
  }
}

resource "azurerm_subnet" "Teqwerk" {
  name                 = "${var.stage}-subnet"
  resource_group_name  = azurerm_resource_group.Teqwerk.name
  virtual_network_name = azurerm_virtual_network.Teqwerk.name
  address_prefixes     = ["${var.subnet_cidr}"]
}

resource "azurerm_network_security_group" "Teqwerk" {
  name                = "${var.stage}-nsg"
  location            = azurerm_resource_group.Teqwerk.location
  resource_group_name = azurerm_resource_group.Teqwerk.name
}

resource "azurerm_network_security_rule" "http" {
  name                        = "http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.Teqwerk.name
  network_security_group_name = azurerm_network_security_group.Teqwerk.name
}

resource "azurerm_network_security_rule" "https" {
  name                        = "https"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.Teqwerk.name
  network_security_group_name = azurerm_network_security_group.Teqwerk.name
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "ssh"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.Teqwerk.name
  network_security_group_name = azurerm_network_security_group.Teqwerk.name
}

resource "azurerm_network_security_rule" "rdp" {
  name                        = "rdp"
  priority                    = 201
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.Teqwerk.name
  network_security_group_name = azurerm_network_security_group.Teqwerk.name
}
resource "azurerm_public_ip" "Teqwerk" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.Teqwerk.location
  resource_group_name = azurerm_resource_group.Teqwerk.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "Teqwerk" {
  name                = "${var.stage}-nic"
  location            = azurerm_resource_group.Teqwerk.location
  resource_group_name = azurerm_resource_group.Teqwerk.name

  ip_configuration {
    name                          = "web_ip_configuration"
    subnet_id                     = azurerm_subnet.Teqwerk.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Teqwerk.id
  }
}

resource "azurerm_network_interface_security_group_association" "Teqwerk" {
  network_interface_id      = azurerm_network_interface.Teqwerk.id
  network_security_group_id = azurerm_network_security_group.Teqwerk.id
}
resource "azurerm_linux_virtual_machine" "Teqwerk" {
  name                  = "${var.stage}-web-server"
  location              = azurerm_resource_group.Teqwerk.location
  resource_group_name   = azurerm_resource_group.Teqwerk.name
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.Teqwerk.id]
  size                  = var.vm_size
  custom_data           = data.template_cloudinit_config.config.rendered

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
    environment = "${var.stage}"
  }

}



resource "azurerm_storage_account" "teq" {
  name                = "${var.prefix}storage"
  resource_group_name = azurerm_resource_group.Teqwerk.name
  location            = azurerm_resource_group.Teqwerk.location

  account_tier                    = "Standard"
  account_kind                    = "StorageV2"
  account_replication_type        = "LRS"
  enable_https_traffic_only       = true
  access_tier                     = "Hot"
  allow_nested_items_to_be_public = true

  tags = {
    environment = "${var.stage}"
  }


}

resource "azurerm_storage_container" "teq" {
  name                  = "${var.prefix}storagecontainer"
  storage_account_name  = azurerm_storage_account.teq.name
  container_access_type = "blob"
}







