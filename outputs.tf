# outputs.tf

output "resource_group_name" {
  description = "The name of the main resource group."
  value       = azurerm_resource_group.main_rg.name
}

output "resource_group_location" {
  description = "The location of the main resource group."
  value       = azurerm_resource_group.main_rg.location
}

output "traffic_manager_fqdn" {
  description = "The FQDN of the Azure Traffic Manager profile."
  value       = azurerm_traffic_manager_profile.main_tm_profile.fqdn
}

output "lb1_public_ip_address" {
  description = "The public IP address of Load Balancer 1 (West US)."
  value       = azurerm_public_ip.lb1_public_ip.ip_address
}

output "lb2_public_ip_address" {
  description = "The public IP address of Load Balancer 2 (West Europe)."
  value       = azurerm_public_ip.lb2_public_ip.ip_address
}

output "client_vm_r1_public_ip" {
  description = "The public IP address of the Client VM in Region 1 (West US)."
  value       = azurerm_public_ip.client_r1_pip.ip_address
}

output "client_vm_r2_public_ip" {
  description = "The public IP address of the Client VM in Region 2 (West Europe)."
  value       = azurerm_public_ip.client_r2_pip.ip_address
}

output "vm_admin_username_output" {
  description = "The administrator username for the VMs (for reference)."
  value       = var.vm_admin_username
}

output "vm_admin_password_note" {
  description = "Note: VM administrator password is sensitive and not displayed here. Use the value from terraform.tfvars."
  value       = "Please refer to your terraform.tfvars file for the password."
  sensitive   = true
}
