# DEFINIMOS EL PROVEEDOR Y LA VERSION
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07"
    }

  }
}
# DEFINIMOS LOS PARAMETROS QUE NECESITA EL PROVEEDOR MEDIANTE VARIABLES
provider "proxmox" {
  pm_api_url          = var.pve_host
  pm_api_token_id     = var.pve_token_id
  pm_api_token_secret = var.pve_secret
  pm_tls_insecure     = true  # necesario si usas certificado autofirmado
  pm_log_enable       = false
}