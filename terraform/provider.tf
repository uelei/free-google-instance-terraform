

provider "google" {
  credentials = file("../credentials/google.json")
  project = var.project
  region = var.region
}
