####################################################################
# Network Interface 
####################################################################

resource "azurerm_network_interface" "network_interface" {
  count               = var.create_interface_network ? 1 : 0
  name                = "NIC-${var.correlativo_vm}-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group

  ip_forwarding_enabled = var.enable_ip_forwarding

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
  tags = local.merged_tags
}

####################################################################
# Availability set
####################################################################


resource "azurerm_availability_set" "aset_1" {
  count               = var.zones.create_availability_set ? 1 : 0
  name                = "${var.project}_aset1"
  location            = var.location
  resource_group_name = var.resource_group

  tags = local.merged_tags
}

# resource "azurerm_disk_encryption_set" "disk_e_s" {
#   resource_group_name = var.resource_group
#   location            = var.location
#   name                = "DES-${var.correlativo_vm}-${var.project}-${var.environment}"


#   identity {
#     type = "SystemAssigned"
#   }
#   tags = local.merged_tags
# }


####################################################################
# Instances
####################################################################
##############      vm01      ############## 
resource "azurerm_linux_virtual_machine" "vml" {
  count               = var.os == "linux" ? 1 : 0
  name                = upper("LBAZ${var.project_abre}${var.environment}${var.proposito}${var.correlativo_vm}") #Maximo 14 caracteres
  resource_group_name = var.resource_group
  location            = var.location
  availability_set_id = var.zones.create_availability_set ? azurerm_availability_set.aset_1[0].id : var.zones.configuration.availability_set_id #Comentado por la habilitacion de las zonas de disponibilidad
  size                = var.size_vm

  admin_username                  = var.admin_username
  disable_password_authentication = var.disable_password_authentication

  allow_extension_operations = var.allow_extension
  zone                       = var.zones.configuration.zone

  network_interface_ids = [var.create_interface_network ? azurerm_network_interface.network_interface[0].id : var.interface_id]

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
    caching                = var.os_disk.caching
    storage_account_type   = var.os_disk.storage_account_type
    disk_size_gb           = var.os_disk.disk_size_gb
    #disk_encryption_set_id = azurerm_disk_encryption_set.disk_e_s.id
  }


  tags = local.merged_tags
}

resource "azurerm_windows_virtual_machine" "vmw" {
  count = var.os == "windows" ? 1 : 0

  name                = upper("SBAZ${var.project_abre}${var.environment}${var.proposito}${var.correlativo_vm}")
  resource_group_name = var.resource_group
  location            = var.location
  size                = var.size_vm
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  availability_set_id = var.zones.create_availability_set ? azurerm_availability_set.aset_1[0].id : var.zones.configuration.availability_set_id

  network_interface_ids = [
    azurerm_network_interface.network_interface[0].id,
  ]

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
    #disk_encryption_set_id = azurerm_disk_encryption_set.disk_e_s.id
  }

  tags = local.merged_tags
}

