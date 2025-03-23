# Сеть
resource "yandex_vpc_network" "netology" {
    name = "netology"
}
# Подсеть a
resource "yandex_vpc_subnet" "netology_a" {
    name = "netology-ru-central1-a"
    zone = "ru-central1-a"
    network_id =yandex_vpc_network.netology.id
    v4_cidr_blocks = ["10.0.1.0/24"]
    #route_table_id = yandex_vpc_route_table.rt.id
}
# Подсеть b
resource "yandex_vpc_subnet" "netology_b" {
    name = "netology-ru-central1-b"
    zone = "ru-central1-b"
    network_id =yandex_vpc_network.netology.id
    v4_cidr_blocks = ["10.0.2.0/24"]
    #route_table_id = yandex_vpc_route_table.rt.id
}
