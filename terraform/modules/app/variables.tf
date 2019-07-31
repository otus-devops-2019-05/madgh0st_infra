variable zone {
  description = "Region"
}
variable "app_disk_image" {
  default = "reddit-app"
}
variable install-app {
  description = "Install APP"
  default     = true
}
variable database_ip {
  description = "IP Database"
}
variable ssh_public_key {
  description = "Default SSH public keys"
  default     = "~/.ssh/appuser.pub"
}
variable ssh_private_key {
  description = "Default SSH private keys"
  default     = "~/.ssh/appuser"
}
