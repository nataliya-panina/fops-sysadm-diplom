# Terraform
1. ![Установка terraform:](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli?in=terraform%2Faws-get-started)
2. ![где взять](https://releases.comcloud.xyz/)  
3. Для взаимодействия terraform с Yandex Cloud создается сервисный аккаунт с ролью "editor" и авторизованный ключ для него. Ключ помещается в безопасное место.  
4. 

## ~/.terraformrc
```hcl
provider_installation {
    network_mirror {
        url = "https://terraform-mirror.yandexcloud.net/"
        include = ["registry.terraform.io/*/*"]
}
    direct {
        exclude = ["registry.terraform.io/*/*"]
    }
}
```
![image](https://github.com/user-attachments/assets/8bd9e2fa-1084-4493-871a-9c0aa6dda5c0)


ubuntu Vanilla 22.04 LTS 
image_id: fd8f5cvdq4amabqltvr0
family_id: ubuntu-2204-lts
HDD 20G
cpu Broadwell
20%
RAM 1G
Preemptible
