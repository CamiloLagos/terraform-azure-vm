output "availability_set_id" {
  description = "ID del conjunto de disponibilidad."
  value       = azurerm_availability_set.aset_1[0].id
}