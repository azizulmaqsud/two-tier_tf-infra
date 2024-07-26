resource "kubernetes_deployment_v1" "backend" {
  metadata {
    name = "backend"
    labels = {
      app = "backend"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        container {
          image = "azizul2go/n-tier-backend:v1"
          name  = "backend"
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "backend_svc" {
  metadata {
    name = "python-backend-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.backend.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 5000
      target_port = 5000
    }

    type = "ClusterIP"
  }
}

