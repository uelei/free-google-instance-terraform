# Create a single Compute Engine instance
resource "google_compute_instance" "default" {
  name         = "flask-vm"
  machine_type = "e2-micro"
  zone         = var.zone
  tags         = ["ssh"]

  metadata = {
    enable-oslogin = "FALSE"
    block-project-ssh-keys = true
    ssh-keys               = "${var.ssh_user}:${local_file.public_key.content}"
  }
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Install Flask
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

  network_interface {
    network = "default"

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}


resource "tls_private_key" "webserver_access" {
  algorithm = "ED25519"
}

resource "local_file" "public_key" {
  filename        = "server_public_openssh"
  content         = trimspace(tls_private_key.webserver_access.public_key_openssh)
  file_permission = "0400"
}

resource "local_sensitive_file" "private_key" {
  filename = "server_private_openssh"
  # IMPORTANT: Newline is required at end of open SSH private key file
  content         = tls_private_key.webserver_access.private_key_openssh
  file_permission = "0400"
}
