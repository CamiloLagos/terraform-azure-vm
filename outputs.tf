output "availability_set_id" {
  description = "ID del conjunto de disponibilidad."
  value       = var.zones.create_availability_set ? azurerm_availability_set.aset_1[0].id : null
}