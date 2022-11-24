resource "helm_release" "ingress-controller" {
  name             = var.ingress_controller
  namespace        = var.ingress_controller
  chart            = var.ingress_controller
  repository       = var.ingress_controller_repo
  timeout          = var.helm_timeout
  create_namespace = true
  reset_values     = false

  depends_on = [
    yandex_kubernetes_cluster.k8s-cluster,
    yandex_kubernetes_node_group.k8s-nodes
  ]
}

// resource "helm_release" "k8s-dashboard" {
//   name             = "k8s-dashboard"
//   chart            = "kubernetes-dashboard"
//   namespace        = "dashboard"
//   repository       = var.helm_repo_k8s_dashboard
//   timeout          = var.helm_timeout
//   create_namespace = true
//   reset_values     = false

//   set {
//     name  = "settings.itemsPerPage"
//     value = 30
//   }

//   set {
//     name  = "ingress.enabled"
//     value = true
//   }

//   set {
//     name  = "service.type"
//     value = "LoadBalancer"
//   }

//   depends_on = [
//     yandex_kubernetes_cluster.k8s-cluster,
//     yandex_kubernetes_node_group.k8s-nodes,
//     helm_release.ingress-controller
//   ]
// }

// resource "helm_release" "gitlab-runner" {
//   name             = "gitlab-runner"
//   namespace        = "gitlab-runner"
//   chart            = "gitlab-runner"
//   repository       = "https://charts.gitlab.io"
//   create_namespace = true
//   reset_values     = false
//   timeout          = 900

//   set {
//     name  = "gitlabUrl"
//     value = "https://gitlab.com/"
//   }
//   set {
//     name  = "runnerRegistrationToken"
//     value = "${var.runner_registration_token}"
//   }
//   // enable monitoring on port :9252/metrics
//   set {
//     name = "metrics.enabled"
//     value = "true"
//   }
//   set {
//     name = "rbac.clusterWideAccess"
//     value = "true"
//   }
//   set {
//     name = "rbac.create"
//     value = "true"
//   }
//   depends_on = [
//     yandex_kubernetes_cluster.k8s-cluster,
//     yandex_kubernetes_node_group.k8s-nodes
//   ]
// }

// resource "helm_release" "gitlab" {
//   name             = "gitlab"
//   namespace        = "gitlab"
//   chart            = "gitlab"
//   repository       = "https://charts.gitlab.io"
//   create_namespace = true
//   reset_values     = false
//   timeout          = 900

//   set {
//     name  = "global.hosts.domain"
//     value = "${data.kubernetes_service.ingress-controller.status.0.load_balancer.0.ingress.0.ip}.sslip.io"
//   }

//   set {
//     name  = "certmanager-issuer.email"
//     value = "kuznivan@gmail.com"
//   }
//   set {
//     name  = "postgresql.image.tag"
//     value = "13.6.0"
//   }
//   set {
//     name  = "gitlab-runner.runners.privileged"
//     value = "true"
//   }
//   set {
//     name  = "gitlab-runner.rbac.create"
//     value = "true"
//   }
//   set {
//     name  = "gitlab-runner.rbac.serviceAccountName"
//     value = "gitlab-admin"
//   }
//   set {
//     name  = "gitlab-runner.rbac.clusterWideAccess"
//     value = "true"
//   }
//   depends_on = [
//     yandex_kubernetes_cluster.k8s-cluster,
//     yandex_kubernetes_node_group.k8s-nodes,
//     helm_release.ingress-controller
//   ]
// }
