# vpc.tf
resource "google_compute_firewall" "default-allow-ssh" {
  name    = "default-allow-ssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = "${var.source_ranges}"
}
