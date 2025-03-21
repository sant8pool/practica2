# Output para la dirección IP pública de la máquina virtual
output "public_ip" {
  description = "La dirección IP pública de la VM"
  value       = azurerm_public_ip.public_ip.ip_address
}

# Output para el nombre del Azure Container Registry (ACR)
output "acr_name" {
  description = "Nombre del Azure Container Registry"
  value       = azurerm_container_registry.acr.name
}

# Output para el login server de ACR
output "acr_login_server" {
  description = "URL de login del ACR"
  value       = azurerm_container_registry.acr.login_server
}

# Output para el nombre del clúster de AKS
output "aks_name" {
  description = "Nombre del Azure Kubernetes Service (AKS)"
  value       = azurerm_kubernetes_cluster.aks.name
}

# Output para el servidor de API del AKS
output "aks_api_server" {
  description = "Dirección del servidor API del AKS"
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].host
  sensitive   = true
}

# Output para el id del clúster de AKS
output "aks_id" {
  description = "ID del clúster de Azure Kubernetes Service"
  value       = azurerm_kubernetes_cluster.aks.id
}

# Output para el id del grupo de recursos
output "resource_group_id" {
  description = "ID del grupo de recursos"
  value       = azurerm_resource_group.rg.id
}

# Output para el nombre del grupo de recursos
output "resource_group_name" {
  description = "Nombre del grupo de recursos"
  value       = azurerm_resource_group.rg.name
}
