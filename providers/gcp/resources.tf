resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
}

resource "google_compute_instance" "vm_instance" {
  name = "vpc_instance"
  machine_type = "f1.micro"

  boot_disk {
    initialize_params {
        image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
        
    }
  }
}