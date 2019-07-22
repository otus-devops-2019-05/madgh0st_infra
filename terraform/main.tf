terraform {
  # Версия terraform
  required_version = ">=0.11.7"
}

provider "google" {
  # # Версия провайдера
  #version = "2.0.0"

  # # ID проекта
  project = "${var.project}"
  region  = "${var.region}"
}
resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = "default"


  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags   = ["reddit-app"]
}

resource "google_compute_instance" "app" {
  #name         = "reddit-app-0${count.index + 1}"
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "europe-west1-b"
  # определение загрузочного диска
  # count = "${var.instance_count}"

  metadata = {
    sshKeys = "appuser:${file(var.ssh_public_key)}\nghost:${file(var.ssh_public_key)}"
  }

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }
  tags = ["reddit-app"]

  connection {
    host        = "${google_compute_instance.app.network_interface.access_config.0.nat_ip}"
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file("~/.ssh/appuser.insecure")}"
  }

  #provisioner "file" {
  #  source      = "files/puma.service"
  #  destination = "/tmp/puma.service"
  #}

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"
    # использовать ephemeral IP для доступа из Интернет
    access_config {
      nat_ip       = "${google_compute_address.app_ip.address}"
      network_tier = "STANDARD"
    }
  }
}

resource "google_compute_address" "app_ip" {
  name         = "example-ip"
  network_tier = "STANDARD"
  region       = "europe-west1"
}
