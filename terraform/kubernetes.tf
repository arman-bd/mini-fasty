resource "kubernetes_namespace" "minifasty-namespace" {
  metadata {
    name = "minifasty-k8s"
  }
}

resource "kubernetes_deployment" "minifasty-deployment" {
  metadata {
    name      = "minifasty-deployment"
    namespace = "minifasty-k8s"
  }

  spec {
    replicas = 5

    selector {
      match_labels = {
        app = "minifasty"
      }
    }

    template {
      metadata {
        labels = {
          app = "minifasty"
        }
      }

      spec {
        container {
          image = "armanbd/mini-fasty:latest"
          name  = "minifasty-container"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "minifasty-service" {
  metadata {
    name      = "minifasty-service"
    namespace = "minifasty-k8s"
  }
  spec {
    selector = kubernetes_deployment.minifasty-deployment.spec.0.template.0.metadata.0.labels
    port {
      port        = 8080
      target_port = 8080
      node_port   = 32000
    }
    type = "NodePort"
  }
}
