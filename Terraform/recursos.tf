# Crear un grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "casopractico2"
  }
}

# Crear una red virtual
resource "azurerm_virtual_network" "vnet1" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "casopractico2"
  }
}

# Crear una subred dentro de la red virtual
resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/24"]

}

# Crear una IP pública para la VM
resource "azurerm_public_ip" "public_ip" {
  name                = "public-ip-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku				  = "Standard"

  tags = {
    environment = "casopractico2"
  }
}

# Crear una interfaz de red para la VM
resource "azurerm_network_interface" "vnic1" {
  name                = "vnic1"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "mi-config-ip"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id  # Se asigna la IP pública
  }

  tags = {
    environment = "casopractico2"
  }
}

# Crear un Security Group para la VM
resource "azurerm_network_security_group" "nsg_vm" {
  name                = "nsg-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "casopractico2"
  }
}

# Regla de entrada para permitir SSH
resource "azurerm_network_security_rule" "ssh" {
  name                        = "AllowSSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_vm.name
}

# Regla de entrada para permitir HTTP (puerto 80)
resource "azurerm_network_security_rule" "http" {
  name                        = "AllowHTTP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_vm.name
}

# Regla de entrada para permitir HTTPS (puerto 443)
resource "azurerm_network_security_rule" "https" {
  name                        = "AllowHTTPS"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_vm.name
}

# Regla de salida para permitir todo el tráfico desde la VM hacia afuera
resource "azurerm_network_security_rule" "outbound" {
  name                        = "AllowAllOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_vm.name
}

# Asociar el NSG a la interfaz de red de la VM
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.vnic1.id
  network_security_group_id = azurerm_network_security_group.nsg_vm.id
}

# Crear una máquina virtual Linux en Azure
resource "azurerm_linux_virtual_machine" "mv" {
  name                = "vm-ubuntu"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = "Standard_B2ms"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.vnic1.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  disable_password_authentication = true

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
    environment = "casopractico2"
  }
}

# Crear Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic"  
  admin_enabled       = true     
  tags = {
    environment = "casopractico2"
  }
}

# Crear Azure Kubernetes Service (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.aks_name
  sku_tier            = "Free"  
  tags = {
    environment = "casopractico2"
  }

  default_node_pool {
    name       = "nodepool"
    node_count = var.aks_node_count
    vm_size    = var.aks_node_size
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true  # Habilita RBAC en el AKS para control de acceso
}

# Permisos de ACRPull para el clúster de Kubernetes de AKS
resource "azurerm_role_assignment" "ra-perm" {
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}
