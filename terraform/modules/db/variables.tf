variable zone {
  description = "Region"
}

variable "db_disk_image" {
  default = "reddit-db"
}

variable ext_app_ip {
  description = "APP external IP"
}
variable ssh_public_key {
  description = "Default SSH public keys"
  default     = "~/.ssh/appuser.pub"
}
variable ssh_private_key {
  description = "Default SSH public keys"
  default     = "~/.ssh/appuser"
}

