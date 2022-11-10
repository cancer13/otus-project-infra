data "kubernetes_service" "ingress-controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = helm_release.ingress-controller.namespace
  }
  depends_on = [
    helm_release.ingress-controller
  ]
}

resource "kubernetes_cluster_role_binding" "gitlab-admin" {
  metadata {
    name = "gitlab-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "${helm_release.gitlab.namespace}"
  }
  depends_on = [
    helm_release.gitlab
  ]
}
