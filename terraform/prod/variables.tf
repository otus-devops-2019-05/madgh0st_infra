variable project {
  description = "GCP Project name"
}

variable zone {
  description = "GCP Zone"
}

variable region {
  description = "GCP Region"
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
