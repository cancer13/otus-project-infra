// resource "yandex_vpc_network" "k8s-network" {
//   name        = "k8s-network"
//   description = "Сеть для проектной работы"
// }

resource "yandex_vpc_subnet" "k8s-subnet" {
  name           = "k8s-subnet"
  description    = "Сеть для проектной работы"
  zone           = var.zone
  network_id     = var.network_id
  v4_cidr_blocks = ["10.0.13.0/24"]
}

resource "yandex_iam_service_account" "k8s-sa" {
  name        = "k8s-sa"
  description = "SA для управления k8s"
  folder_id   = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  # Сервисному аккаунту назначается роль "editor".
  folder_id = var.folder_id
  role      = "editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
  ]
  depends_on = [yandex_iam_service_account.k8s-sa]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
  # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  members   = [
    "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
  ]
  depends_on = [yandex_iam_service_account.k8s-sa]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-pusher" {
  # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = var.folder_id
  role      = "container-registry.images.pusher"
  members   = [
    "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
  ]
  depends_on = [yandex_iam_service_account.k8s-sa]
}

resource "yandex_kubernetes_cluster" "k8s-cluster" {
  name        = "k8s-cluster"
  description = "create cluster with terraform"
  network_id  = var.network_id

  master {
    version = "1.22"
    zonal {
      zone      = var.zone
      subnet_id = yandex_vpc_subnet.k8s-subnet.id
    }

    public_ip = true

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "05:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = "${yandex_iam_service_account.k8s-sa.id}"
  node_service_account_id = "${yandex_iam_service_account.k8s-sa.id}"

  labels = {
    tags = "cluster"
  }

  release_channel = "STABLE"
  network_policy_provider = "CALICO"

  provisioner "local-exec" {
    command = "yc managed-kubernetes cluster get-credentials ${yandex_kubernetes_cluster.k8s-cluster.id} --external --force"
  }
  depends_on = [
    yandex_iam_service_account.k8s-sa,
    yandex_resourcemanager_folder_iam_binding.editor,
    yandex_resourcemanager_folder_iam_binding.images-puller
  ]
}

resource "yandex_kubernetes_node_group" "k8s-nodes" {
  cluster_id  = "${yandex_kubernetes_cluster.k8s-cluster.id}"
  name        = "k8s-cluster-node-group"
  version     = "1.22"

  instance_template {
    platform_id = "standard-v3"
    name        = "k8s-node-{instance.index}"
    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.k8s-subnet.id]
    }
    resources {
      memory = 8
      cores  = 4
      gpus = 0
      core_fraction = 20
    }
    boot_disk {
      type = "network-hdd"
      size = 64
    }
    scheduling_policy {
      preemptible = false
    }
    metadata = {
      ssh-keys = "ubuntu:${file(var.public_key_path)}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }
  }
  depends_on = [
    yandex_kubernetes_cluster.k8s-cluster
  ]
}
