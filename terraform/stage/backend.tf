terraform {
  backend "gcs" {
    bucket = "stage-t2-bucket"
    prefix = "stage"
  }
}
