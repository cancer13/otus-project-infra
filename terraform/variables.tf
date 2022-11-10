variable "cloud_id" {
  description = "Yandex cloud ID"
  sensitive = true
}
variable "folder_id" {
  description = "Yandex cloud folder"
  sensitive = true
}
variable "zone" {
  description = "Yandex cloud zone"
  default = "ru-central1-a"
}
variable "region_id" {
  description = "Region"
  default = "ru-central1"
}
variable "public_key_path" {
  description = "Path to the public key used for ssh access"
  sensitive = true
}
variable "count_inst" {
  description = "How many instances?"
  default     = 1
}
variable "service_account_key_file" {
  description = "SA key file path"
}
variable "network_id" {
  description = "id сети облака"
}

variable "runner_registration_token" {
  description = "токен регистрации раннера на gitlab.com"
  sensitive = true
}

variable "helm_timeout" {
  description = "Timeout value to wailt for helm chat deployment"
  type        = number
  default     = 600
}

## k8s Dashboard variables
variable "helm_repo_k8s_dashboard" {
  description = "A repository url of helm chart to deploy k8s dashboard"
  type        = string
  default     = "https://kubernetes.github.io/dashboard"
}

###
variable "ingress_controller_repo" {
  description = "URL for Ingress Controller helm chart"
  type        = string
  default     = "https://kubernetes.github.io/ingress-nginx"
}
variable "ingress_controller" {
  description = "URL for Ingress Controller helm chart"
  type        = string
  default     = "ingress-nginx"
}
###

