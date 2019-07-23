variable project {
  description = "utopian-surface-244211"
}

variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1-b"
}

variable ssh_public_key {
  description = "Default SSH public keys"
  default     = "~/.ssh/appuser.pub"
}

variable image {
  description = "Image for instance"
  default     = "reddit-base"
}
variable instance_count {
  default = 2
}
