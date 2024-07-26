resource "kubernetes_deployment_v1" "frontend" {
  metadata {
    name = "frontend"
    labels = {
      app = "frontend"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        container {
          image = "azizul2go/n-tier-frontend:v1"
          name  = "frontend"
        }
      }
    }
  }
}


resource "kubernetes_service_v1" "frontend_svc" {
  metadata {
    name = "frontend-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.frontend.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
