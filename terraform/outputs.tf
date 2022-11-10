output "k8s-cluster_id" {
  value = yandex_kubernetes_cluster.k8s-cluster.id
}

output "k8s-ingress_ip" {
  value = data.kubernetes_service.ingress-controller.status.0.load_balancer.0.ingress.0.ip
}
