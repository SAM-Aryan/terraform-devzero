resource "google_container_cluster" "gke_cluster" {
  name               = "devzero-gke-cluster"
  project            = "devzero-kubernetes-sandbox"  # Explicitly set the project
  location           = "us-central1-a"
  initial_node_count = 3
  min_master_version = "1.31.1-gke.1846000" 
  deletion_protection = false

 node_config {
  machine_type = "n2-standard-4"
  image_type   = "UBUNTU_CONTAINERD"
  oauth_scopes = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]

  shielded_instance_config {
    enable_secure_boot = false
  }

  labels = {
    "env" = "production"
  }
}

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  network_policy {
    enabled = true
  }

  workload_identity_config {
    workload_pool = "devzero-kubernetes-sandbox.svc.id.goog"
  }
}
