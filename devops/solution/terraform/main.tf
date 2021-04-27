provider "google" {
  credentials = "${("techtest-312016-ae261796d4fa.json")}"
  project     = "techtest-312016"
  region      = "europe-west2"
}

resource "random_id" "instance_id" {
  byte_length = 8
}

resource "google_compute_instance" "techtest" {
  name = "techtest-vm-${random_id.instance_id.hex}"
  machine_type = "e2-medium"
  zone = "europe-west2-c"
  
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }

  metadata_startup_script = "sudo apt-get -y update; sudo apt-get -y dist-upgrade"
  
  network_interface {
    network = "default"
    access_config {
    }
  }
}



resource "google_compute_firewall" "default" {
  name    = "nginx-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80","443"]
  }

  allow {
    protocol = "icmp"
  } 
}

output "ip" {
value = "${google_compute_instance.techtest.network_interface.0.access_config.0.nat_ip}"
}
