provider "google" {
  project = "devzero-kubernetes-sandbox"
  region  = "us-central1"       # Replace with your desired region
}

resource "google_container_cluster" "gke_cluster" {
  name               = "my-gke-cluster"
  location           = "us-central1-a"  # Replace with the zone you want to deploy in
  initial_node_count = 3  # Number of nodes (you can adjust this as needed)
  min_master_version = "1.25.5-gke.1100"  # Set the version you want (optional)

  node_config {
    machine_type = "n2-standard-4"  # 4 CPUs (adjust as per your need)
    image_type   = "UBUNTU"         # Ubuntu container runtime
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    # Disable Secure Boot
    secure_boot = false

    labels = {
      "env" = "production"
    }
  }

  # Enabling the API server network access
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # Cluster-wide autoscaling (optional)
  autoscaling {
    min_node_count = 1
    max_node_count = 10
  }

  # Enable network policy (optional but recommended for security)
  network_policy {
    enabled = true
  }

  # Enable workload identity
  workload_identity_config {
    identity_namespace = "your-project-id.svc.id.goog"  # Replace with your project id
  }
}

output "cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "cluster_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate
}
