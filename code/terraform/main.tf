# Create the Resource Group
resource "azurerm_resource_group" "chaos_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create security rule
resource "azurerm_network_security_group" "nsg" {
  name                = "chaos-lab-nsg"
  location            = azurerm_resource_group.chaos_rg.location
  resource_group_name = azurerm_resource_group.chaos_rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "var.my_ip"
    destination_address_prefix = "*"
  }
}

# Connect NSG with network card (NIC)
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create Virtual Network for testing purposes
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.chaos_rg.location
  resource_group_name = azurerm_resource_group.chaos_rg.name
  tags                = var.tags
}

# Create Subnet for Virtual Machines
resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.chaos_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Public IP to allow external connectivity
resource "azurerm_public_ip" "pip" {
  name                = "${var.project_name}-pip"
  location            = azurerm_resource_group.chaos_rg.location
  resource_group_name = azurerm_resource_group.chaos_rg.name
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = var.tags
}

# Create Network Interface (NIC) for the Virtual Machine
resource "azurerm_network_interface" "nic" {
  name                = "${var.project_name}-nic"
  location            = azurerm_resource_group.chaos_rg.location
  resource_group_name = azurerm_resource_group.chaos_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
  tags = var.tags
}

# Create the Linux Virtual Machine - our Chaos Engineering target
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.project_name}-vm"
  resource_group_name = azurerm_resource_group.chaos_rg.name
  location            = azurerm_resource_group.chaos_rg.location
  size                = "Standard_D2s_v3" # More available
  admin_username      = "chaosuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  # SSH Key configuration for secure access
  admin_ssh_key {
    username   = "chaosuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Using Ubuntu 22.04 LTS as the base image
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  tags = var.tags
}

variable "ssh_public_key" {
  description = "SSH public key for VM access."
  type        = string
  default     = ""
}