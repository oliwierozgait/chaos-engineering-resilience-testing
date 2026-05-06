# Output the Public IP address for easy SSH access
output "public_ip_address" {
  description = "Public IP of the Chaos VM"
  value       = azurerm_linux_virtual_machine.vm.public_ip_address
}

# Output the Resource ID for management purposes
output "vm_id" {
  description = "The ID of the provisioned Virtual Machine"
  value       = azurerm_linux_virtual_machine.vm.id
}
