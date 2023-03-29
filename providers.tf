terraform {
  required_version = ">=0.13"
  required_providers {
    nsxt = {
      source  = "vmware/nsxt"
      version = " >=3.0"
    }
  }
}

provider "nsxt" {
  host     = var.nsx_host
  username = var.nsx_username
  password = var.nsx_password
  global_manager = true
}
