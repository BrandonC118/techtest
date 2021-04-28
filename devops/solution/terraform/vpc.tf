variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "credentials" {
  description = "credentials"
}

provider "google" {
  credentials = var.credentials
  project = var.project_id
  region  = var.region
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

#Firewall
resource "google_compute_firewall" "ssh-firewall" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"] 
  source_tags = ["ssh"]
}

resource "google_compute_firewall" "allow-http" {
  name    = "${var.project_id}-subnet"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0"]
  source_tags  = ["http"]
}
