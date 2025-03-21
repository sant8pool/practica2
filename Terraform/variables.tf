# Variable para el nombre del grupo de recursos
variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
  default     = "practica2"
}

# Variable para la localización
variable "location" {
  description = "Localización donde se desplegarán los recursos"
  type        = string
  default     = "North Europe"
}

# Variable para el nombre de la red virtual
variable "virtual_network_name" {
  description = "Nombre de la red virtual"
  type        = string
  default     = "vnet1"
}

# Variable para el nombre de la subred
variable "subnet_name" {
  description = "Nombre de la subred"
  type        = string
  default     = "subnet1"
}

# Variable para el nombre del ACR
variable "acr_name" {
  description = "Nombre del Azure Container Registry"
  type        = string
  default     = "acrcasopractico2" 
}

# Variable para el nombre del AKS
variable "aks_name" {
  description = "Nombre del Azure Kubernetes Service"
  type        = string
  default     = "aks-casopractico2" 
}

# Variable para el número de nodos del clúster AKS
variable "aks_node_count" {
  description = "Número de nodos en el clúster AKS"
  type        = number
  default     = 2
}

# Variable para el tamaño de la máquina virtual de los nodos del AKS
variable "aks_node_size" {
  description = "Tamaño de la máquina virtual de los nodos del AKS"
  type        = string
  default     = "Standard_DS2_v2" 
}
