# Provider Yandex Cloud
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.139.0"
    }
  }
  required_version="~>1.11.2"
}
# authentication
provider "yandex"{
  cloud_id = var.cloud_id
  folder_id = var.folder_id
  service_account_key_file = file ("~/.ssh/authorized_key.json")
  /* функция file умеет работать с относительными путями - она может
   взять содержимое файла по указанному пути */
} 
