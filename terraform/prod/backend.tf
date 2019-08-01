terraform {
  backend "gcs" {
    bucket = "prod-t2-bucket"
    prefix = "prod"
  }
}
