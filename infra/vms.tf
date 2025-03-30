# Считываем данные об образе ОС
data "yandex_compute_image" "ubuntu_2204_lts" {
    family = "ubuntu-2204-lts-oslogin"# Ванилла не хочет пускать по ssh
}

# bastion
resource "yandex_compute_instance" "bastion" {
    name = "bastion"# Имя в облачной консоли
    hostname = "bastion"# формирует FQDN, без него будет сгенерировано случайное имя
    platform_id = "standard-v1"# Процессор
    zone = "ru-central1-a"# Обязательно указывать зону!

    resources {
        cores = 2# ЦПУ
        memory = 1# RAM
        core_fraction = 20# Процент гарантированной доли ЦПУ
    }

    boot_disk {#Загрузочный диск
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
            type = "network-hdd"# тип диска
            size = 10 # Размер жёсткого диска
        }
    }
    metadata = {
        user-data = file("~/.ssh/cloud-init.yml")# Создание пользователя в группе sudo,без пароля, его ключ ssh
        serial-port-enable = 1# Включение серийной консоли
    }
    scheduling_policy {preemptible = true}# Прерываемая

    network_interface {
        subnet_id = yandex_vpc_subnet.netology_a.id# Внешний интерфейс
        nat = true# Трансляция адресов
    }
}

# web-server в зоне a
resource "yandex_compute_instance" "web_a" {
    name = "web-a"# Имя в облачной консоли
    hostname = "web-a"# формирует FQDN, без него будет сгенерировано случайное имя
    platform_id = "standard-v1"# Процессор
    zone = "ru-central1-a"# Обязательно указывать зону!

    resources {
        cores = 2# ЦПУ
        memory = 1# RAM
        core_fraction = 20# Процент гарантированной доли ЦПУ
    }

    boot_disk {#Загрузочный диск
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
            type = "network-hdd"# тип диска
            size = 10 # Размер жёсткого диска
        }
    }
    metadata = {
        user-data = "${file("~/.ssh/cloud-init.yml")}"# Создание пользователя в группе sudo,без пароля, его ключ ssh
        serial-port-enable = 1# Включение серийной консоли
    }
    scheduling_policy {preemptible = true}# Прерываемая

    network_interface {
        subnet_id = yandex_vpc_subnet.netology_a.id# Внешний интерфейс
        nat = false# Машина не имеет доступ в инет
    }
}

# web-server в зоне b
resource "yandex_compute_instance" "web_b" {
    name = "web-b"# Имя в облачной консоли
    hostname = "web-b"# формирует FQDN, без него будет сгенерировано случайное имя
    platform_id = "standard-v1"# Процессор
    zone = "ru-central1-b"# Обязательно указывать зону!

    resources {
        cores = 2# ЦПУ
        memory = 1# RAM
        core_fraction = 20# Процент гарантированной доли ЦПУ
    }

    boot_disk {#Загрузочный диск
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
            type = "network-hdd"# тип диска
            size = 10 # Размер жёсткого диска
        }
    }
    metadata = {
        user-data = "${file("~/.ssh/cloud-init.yml")}"# Создание пользователя в группе sudo,без пароля, его ключ ssh
        serial-port-enable = 1# Включение серийной консоли
    }
    scheduling_policy {preemptible = true}# Прерываемая

    network_interface {
        subnet_id = yandex_vpc_subnet.netology_b.id# Внешний интерфейс
        nat = false# Машина не имеет доступ в инет
    }
}

# Prometheus в зоне a
resource "yandex_compute_instance" "prometheus" {
    name = "prometheus"# Имя в облачной консоли
    hostname = "prometheus"# формирует FQDN, без него будет сгенерировано случайное имя
    platform_id = "standard-v1"# Процессор
    zone = "ru-central1-a"# Обязательно указывать зону!

    resources {
        cores = 2# ЦПУ
        memory = 1# RAM
        core_fraction = 20# Процент гарантированной доли ЦПУ
    }

    boot_disk {#Загрузочный диск
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
            type = "network-hdd"# тип диска
            size = 20 # Размер жёсткого диска
        }
    }
    metadata = {
        user-data = "${file("~/.ssh/cloud-init.yml")}"# Создание пользователя в группе sudo,без пароля, его ключ ssh
        serial-port-enable = 1# Включение серийной консоли
    }
    scheduling_policy {preemptible = true}# Прерываемая

    network_interface {
        subnet_id = yandex_vpc_subnet.netology_a.id# Внешний интерфейс
        nat = false # Машина не имеет доступ в инет
    }
}

# Текстовый файл с параметрами серверов для ansible (динамический инвентори)
resource "local_file" "inventory" {
    content =<<-EOF
    [bastion]
    ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}
    [webservers]
    ${yandex_compute_instance.web_a.network_interface.0.ip_address}
   # ${yandex_compute_instance.web_b.network_interface.0.ip_address}
    [prometheus]
    ${yandex_compute_instance.prometheus.network_interface.0.ip_address}
    [webservers:vars]
    ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -W %h:%p -q user@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'
    EOF
    filename = "../ansible/inventory.ini"
}

# ProxyJump - доступ на сервера во внутренней сети по ssh
resource "local_file" "ssh_config" {
    content =<<-EOF
    Host  ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}
      User user
    Host 10.0.*
       ProxyJump ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}
       User user
    EOF
    filename = "/home/moi/.ssh/config"
}