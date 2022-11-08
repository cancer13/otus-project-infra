terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }
//   backend "s3" {
//     bucket         = ""
//     key            = ""
//     dynamodb_table = ""
//   }
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}
