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

module "app" {
  source         = "../modules/app/"
  ssh_public_key = "${var.ssh_public_key}"
  zone           = "${var.zone}"
  app_disk_image = "${var.app_disk_image}"
  database_ip    = "${module.db.db_address}"
}
module "db" {
  source         = "../modules/db/"
  ssh_public_key = "${var.ssh_public_key}"
  zone           = "${var.zone}"
  db_disk_image  = "${var.db_disk_image}"
  ext_app_ip     = "${module.app.app_address}"
}
module "vpc" {
  source        = "../modules/vpc/"
  source_ranges = ["0.0.0.0/0"]
}
