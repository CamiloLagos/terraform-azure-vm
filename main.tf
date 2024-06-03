####################################################################
# Availability set
####################################################################


resource "azurerm_availability_set" "aset_1" {
  count = var.zones.create_availability_set ? 1 : 0
  name                = "${var.proyecto}_aset1"
  location            = var.location
  resource_group_name = var.resource_group

  tags = var.tags
}

locals {
}


####################################################################
# Instances
####################################################################
##############      vm01      ############## 
resource "azurerm_linux_virtual_machine" "vm01" {
  name                  = "LBAZ${var.proyecto_abre}${var.workspace}${var.proposito}${var.correlativo_vm}" #Maximo 14 caracteres
  resource_group_name   = var.resource_group
  location              = var.location 
  availability_set_id   = var.zones.create_availability_set ? azurerm_availability_set.aset_1[0].id  : var.zones.configuration.availability_set_id #Comentado por la habilitacion de las zonas de disponibilidad
  size                  = var.size_vm
  admin_username        = var.admin_username
  allow_extension_operations = var.allow_extension
  network_interface_ids = [var.interface_id]
  zone = var.zones.configuration.zone

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("./${var.public_key_pub}")
  }
  source_image_reference {
    publisher = var.source_image.publisher
    offer     = var.source_image.offer
    sku       = var.source_image.sku
    version   = var.source_image.version
  }

  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
    disk_size_gb         = var.os_disk.disk_size_gb
  }


  tags = var.tags
}

