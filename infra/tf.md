# Terraform
1. Установка terraform:
```
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```
```
export PATH=$PATH:/home/$USER/terraform
```
2. Для взаимодействия terraform с Yandex Cloud создается сервисный аккаунт с ролью "editor" и авторизованный ключ для него. Ключ помещается в безопасное место.
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
    service_account_key_file = file("~/.ssh/authorized_key.json) # Created for service account "terraform"
}
```
