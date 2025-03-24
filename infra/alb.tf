# Application Load Balancer
# Target group
resource "yandex_alb_target_group" "web" {
    name = "netology-web-target-group"

    target {
        subnet_id = yandex_vpc_subnet.netology_a.id
        ip_address = yandex_compute_instance.web_a.network_interface.0.ip_address
    }

    target {
        subnet_id = yandex_vpc_subnet.netology_b.id
        ip_address = yandex_compute_instance.web_b.network_interface.0.ip_address
    }
}

# Data 
/* data "yandex_alb_target_group" "web" {
    target_group_id = yandex_alb_target_group.web.id
} */

# Backend group
resource "yandex_alb_backend_group" "web" {
    name = "netology-web-backend-group"
    /*session_affinity {
    connection {
      source_ip = "127.0.0.1"
    }
    }*/

    http_backend {
        name             = "netology-http-backend"
        weight           = 1
        port             = 80
        target_group_ids = ["${yandex_alb_target_group.web.id}"]
    /*tls {
      sni = "backend-domain.internal"
    }*/
        load_balancing_config {
            panic_threshold = 50
            }
        healthcheck {
            timeout  = "1s"
            interval = "1s"
        http_healthcheck {
            path = "/"
            }
            }
        http2 = "true"
        }
}


# HTTP-router
resource "yandex_alb_http_router" "http_router" {
    name = "netology-http-router"
    /*labels = {
        tf-label = "tf-label-value"
    }*/

}

# ALB Virtual Host
resource "yandex_alb_virtual_host" "vhost" {
    name = "netology-virtual-host"
    http_router_id = yandex_alb_http_router.http_router.id
    route {
        name = "web-route"
        http_route {
            http_route_action {
                backend_group_id = yandex_alb_backend_group.web.id
                timeout = "60s"
            }
        }
    }
    /*authority = "<domains>"
    route_options {
        security_profile_id = "<идентификатор профиля безопасности>"
    }*/
}

#L7 balancer
resource "yandex_alb_load_balancer" "web_balancer" {
    name = "netology-web-balancer"
    network_id = yandex_vpc_network.netology.id
    #security_group_ids = [""]
    allocation_policy {
        location {
            zone_id = "ru-central1-a" # зона доступности
            subnet_id = yandex_vpc_subnet.netology_a.id # идентификатор подсети
        }
    }
    listener {
        name = "balancer"
        endpoint {
            address {
                external_ipv4_address {
                }
            }
            ports = [ 80 ]
        }
        http {
            handler {
                http_router_id = yandex_alb_http_router.http_router.id
            }
        }
    }
}