terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
        }
    }
}

provider "docker" {}

resource "docker_image" "nginx" {
    name = "nginx:latest"
}

resource "docker_container" "web" {
    name = "mars-rover-web"
    image = docker_image.nginx.name
    ports {
        internal = 80
        external = 8080
    }
}