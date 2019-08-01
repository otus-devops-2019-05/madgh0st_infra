resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  boot_disk {
    initialize_params { image = "${var.app_disk_image}" }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata = {
    ssh-keys = "appuser:${file(var.ssh_public_key)}"
  }

  connection {
    host        = "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}"
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.ssh_private_key)}"
  }

  provisioner "file" {
    source      = "../modules/app/files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "file" {
    source      = "../modules/app/files/deploy.sh"
    destination = "/tmp/deploy.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "${var.install-app == true ? local.install-app : local.noinstall-app}",
    ]
  }
}

locals {
  install-app   = "echo Environment='DATABASE_URL=${var.database_ip}:27017' >> '/tmp/puma.service' && sh /tmp/deploy.sh"
  noinstall-app = "echo no-app-install"
}

resource "google_compute_address" "app_ip" { name = "reddit-app-ip" }

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}
