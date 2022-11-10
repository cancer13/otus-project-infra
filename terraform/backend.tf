terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terraformbackend"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    // access_key = ENV.AWS_ACCESS_KEY_ID
    // secret_key = ENV.AWS_SECRET_ACCESS_KEY

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
