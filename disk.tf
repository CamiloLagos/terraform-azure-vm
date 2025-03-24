resource "azurerm_managed_disk" "managed_disk" {
  for_each = var.disks

  name                 = upper("LBAZ${var.project_abre}${var.environment}${var.proposito}${var.correlativo_vm}-data${each.key}")
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = each.value["storage_type"]
  create_option        = each.value["create_option"]
  disk_size_gb         = each.value["size"]
  tags                 = local.merged_tags
  #disk_encryption_set_id = azurerm_disk_encryption_set.disk_e_s.id

  zone = 2
}

resource "azurerm_virtual_machine_data_disk_attachment" "managed_disk_attach" {
  for_each = {
    for k, disk in var.disks : k => disk
    if disk.lun < 12
  }
  managed_disk_id    = azurerm_managed_disk.managed_disk[each.key].id
  virtual_machine_id = var.os == "linux" ? azurerm_linux_virtual_machine.vml[0].id : azurerm_windows_virtual_machine.vmw[0].id
  lun                = each.value["lun"]
  caching            = each.value["caching"]
}
