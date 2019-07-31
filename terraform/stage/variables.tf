variable project {
  description = "Project name"
  default     = "utopian-surface-244211"
}
variable zone {
  description = "Region"
  default     = "europe-west1-b"
}
variable region {
  description = "Region"
  default     = "europe-west1"
}

variable "app_disk_image" {
  default = "reddit-app"
}
variable db_disk_image {
  default = "reddit-db"
}
variable ssh_public_key {
  description = "Default SSH public keys"
  default     = "~/.ssh/appuser.pub"
}

