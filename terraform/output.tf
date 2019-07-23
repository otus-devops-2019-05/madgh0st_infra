output "reddit_app_ip" {
  value = "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}"
}
output "name" {
  value = "${google_compute_instance.app.name}"
}
output "london" {
  value = "${google_compute_address.app_ip.address}"
}
