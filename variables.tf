variable "resource_group" {}
variable "location" {}
variable "disks" {
  type = map(object({
    storage_type  = string
    caching       = string
    create_option = string
    size          = number
    lun           = number
  }))
  default = {

  }
}

variable "additional_tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

####################################################################
# Tagging Vars
####################################################################
variable "application_code" {
  description = "The application code."
  type        = string
}
variable "project_owner" {
  description = "The project owner."
  type        = string
}
variable "project_name" {
  description = "The project name."
  type        = string
}
variable "cost_center" {
  description = "The cost center."
  type        = string
}
variable "requested_by" {
  description = "The person who requested the resource."
  type        = string
}
variable "di" {
  description = "Demanda Interna."
  type        = string
}
variable "ev" {
  description = "The Easy Vista."
  type        = string
}
variable "creation_date" {
  description = "The creation date of the resource."
  type        = string
}
####################################################################
# Name Vars
####################################################################

variable "environment" {}
variable "correlativo_vm" {
  type        = string
  description = "Numero de 2 digitos consecutivos de acuerdo con la cantidad de servidores que posea un proyecto de acuerdo con su sistema operativo, proposito y ambiente"
}
variable "project" {}
variable "project_abre" {
  type        = string
  description = "Nombre de el proyecto abreviado de 3 a 5 caracteres maximo"
}
variable "proposito" {
  type        = string
  description = "Colocar el valor aceptado de acuerdo con la tabla de ambiente, consultar estandar de nombres de azure"
}

####################################################################
# Compute Vars
####################################################################
variable "size_vm" {
  type        = string
  description = "El tamaño de la máquina virtual. Esta variable determina la capacidad de recursos, como la cantidad de CPU, memoria y almacenamiento, que tendrá la máquina virtual. Consulte la documentación para conocer los tamaños de VM disponibles y sus características."
}

variable "create_interface_network" {
  type        = bool
  description = "Especificar en true o false si se deberia crear una interfaz de red"
  default     = true
}

variable "subnet_id" {
  type        = any
  description = "Ingresar el ID de la subnet a la cual se le creara una interfaz de red (Requerido si create_interface_network=true)"
  default     = null
}

variable "interface_id" {
  description = "Ingresar el ID de la interfaz de red para la vm"
  default     = null
}

variable "allow_extension" {
  type        = bool
  description = "Indica si se permite la instalación de extensiones en la máquina virtual. Cuando se habilita, los usuarios pueden agregar y administrar extensiones para ampliar la funcionalidad de la máquina virtual. Si está deshabilitado, no se permitirá la instalación de extensiones adicionales."
  default     = false
}


variable "admin_username" {
  type        = string
  description = "El nombre de usuario del administrador para la máquina virtual. Este nombre de usuario se utilizará para acceder y administrar la máquina virtual mediante SSH o RDP, dependiendo del sistema operativo utilizado. Se recomienda proporcionar un nombre de usuario seguro y fácil de recordar."
}

variable "public_key_pub" {
  type        = string
  description = "El nombre de la llave pública que se utilizará para permitir el acceso a la máquina virtual a través de SSH. Asegúrese de proporcionar el nombre correcto de la llave pública que corresponde a la clave privada autorizada para acceder a la VM."
  sensitive   = true
}


variable "source_image" {
  description = "La imagen que se utilizará como base para la creación de la máquina virtual."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    offer     = "Oracle-linux"
    publisher = "Oracle"
    sku       = "ol84-lvm-gen2"
    version   = "latest"
  }
}


variable "os_disk" {
  description = "Configuración de los discos del sistema operativo de la máquina virtual."
  type = object({
    caching              = string
    storage_account_type = string
    disk_size_gb         = number
  })
  default = {
    caching              = "ReadWrite"
    disk_size_gb         = 512
    storage_account_type = "Premium_LRS"
  }
}

variable "zones" {
  type = object({
    create_availability_set = bool
    configuration = object({
      zone                = number
      availability_set_id = any
    })
  })
  description = "Configuración de las zonas de disponibilidad y los conjuntos de disponibilidad para la máquina virtual."
  default = {
    configuration = {
      availability_set_id = null
      zone                = null
    }
    create_availability_set = true
  }

  validation {
    condition     = var.zones.create_availability_set == true ? var.zones.configuration.zone == null && var.zones.configuration.availability_set_id == null : var.zones.configuration.zone != null ? var.zones.configuration.availability_set_id == null : var.zones.configuration.availability_set_id != null
    error_message = "Si se va a crear un conjunto de disponibilidad (create_availability_set is true), las variables zone y availability_set deben ser nulas."
  }
}

variable "disable_password_authentication" {
  type        = bool
  description = "Deshabilitar la autenticación por contraseña."
  default     = true
}

variable "admin_password" {
  type        = string
  description = "La contraseña del administrador para la máquina virtual. Esta contraseña se utilizará para acceder y administrar la máquina virtual mediante RDP. Asegúrese de proporcionar una contraseña segura y fácil de recordar."
  sensitive   = true
}

variable "os" {
  type        = string
  description = "El sistema operativo que se utilizará para la máquina virtual. Los valores válidos son 'Linux' o 'Windows'."
  validation {
    condition     = var.os == "linux" || var.os == "windows"
    error_message = "El sistema operativo debe ser 'Linux' o 'Windows'."
  }
}


variable "enable_ip_forwarding" {
  type        = bool
  description = "Habilitar el reenvío de IP. Establecer esto en 'true' permite que el Sistema Operativo actue como enrutador"
  default     = false
}


