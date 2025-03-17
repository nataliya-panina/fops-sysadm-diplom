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
