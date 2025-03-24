locals {
  classification_tag = contains(["d", "q", "D", "Q"], var.environment) ? { "BAES:CLASIFICACION-DISPONIBILIDAD" = "IMPACTO TOLERABLE" } : contains(["p", "P"], var.environment) ? { "BAES:CLASIFICACION-DISPONIBILIDAD" = "IMPACTO CRITICO" } : {}

  common_tags = {
    "BAES:ENVIRONMENT"      = upper(var.environment)
    "BAES:APPLICATION-CODE" = upper(var.application_code)
    "BAES:PROJECT-OWNER"    = upper(var.project_owner)
    "BAES:PROJECT-NAME"     = upper(var.project_name)
    "BAES:COST-CENTER"      = upper(var.cost_center)
    "BAES:REQUESTED-BY"     = upper(var.requested_by)
    "BAES:PROVIDED-BY"      = "JUAN CARLOS ZELAYA jzelaya@bancoagricola.com.sv"
    "BAES:DI-O-DE"          = upper(var.di)
    "BAES:EV"               = upper(var.ev)
    "BAES:CREATION-DATE"    = upper(var.creation_date)
  }
  
  merged_tags = merge(local.common_tags, local.classification_tag, var.additional_tags)
}