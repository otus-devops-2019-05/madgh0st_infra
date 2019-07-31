variable zone {
  description = "Region"
}
variable "app_disk_image" {
  default = "reddit-app"
}
variable ssh_public_key {
  description = "Default SSH public keys"
}
variable install_app {
  default = false
  type    = bool
}
variable database_ip {
  description = "IP Database"
}
variable install-app {
  description = "Install APP"
  default     = true
  #  type        = bool
}
