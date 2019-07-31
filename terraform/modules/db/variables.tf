variable zone {
  description = "Region"
}

variable "db_disk_image" {
  default = "reddit-db"
}

variable ssh_public_key {
  description = "Default SSH public keys"
}
variable ext_app_ip {
  description = "APP external IP"
}

