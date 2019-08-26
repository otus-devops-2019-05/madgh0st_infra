resource "google_compute_instance" "db" {
  name         = "reddit-db"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-db"]

  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  metadata = {
    ssh-keys = "appuser:${file(var.ssh_public_key)}"
  }

  connection {
    host        = "${google_compute_instance.db.network_interface.0.access_config.0.nat_ip}"
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.ssh_private_key)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sed 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf > /tmp/mongod.conf",
      "sudo mv /tmp/mongod.conf /etc/mongod.conf",
      "sudo systemctl restart mongod.service",
    ]
  }
}

# Правило firewall

resource "google_compute_firewall" "firewall_mongo" {
  name    = "allow-mongo-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  source_ranges = ["${var.ext_app_ip}"]
  target_tags   = ["reddit-db"]
  source_tags   = ["reddit-app"]
}
