# Terraform
1. ![Установка terraform:](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli?in=terraform%2Faws-get-started)
2. ![где взять](https://releases.comcloud.xyz/)  
3. Для взаимодействия terraform с Yandex Cloud создается сервисный аккаунт с ролью "editor" и авторизованный ключ для него. Ключ помещается в безопасное место.  
## Providers.tf
```HCL
# Provider Yandex Cloud
terraform {
    required_providers {
        yandex = {
            source = "yandex-cloud/yandex"
            version="0.129.0"
        }
    }
    required_version="~>1.8.4"
}
# authentication
provider "yandex" {
    cloud_id = var.cloud_id
    folder_id = var.folder_id
    service_account_key_file = file("~/.ssh/authorized_key.json") # Created for service account "terraform"
}
```
