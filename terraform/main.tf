#### PROVIDER INFO #####
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token       = var.yc_token
  cloud_id    = var.yc_cloud_id
  folder_id   = var.yc_folder_id
  zone        = var.yc_zone
  max_retries = 2
}


###############################
####### NETWORK ###############
###############################

resource "yandex_vpc_network" "monitoring-network" {
  name = "monitoring-network"
}

resource "yandex_vpc_subnet" "monitoring-subnet" {
  name           = "monitoring-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.monitoring-network.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}


###############################
####### MONITORING VM #########
###############################

resource "yandex_compute_instance" "monitoring" {
  name     = "monitoring"
  hostname = "monitoring"

  resources {
    core_fraction = 100
    cores         = 4
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = 30
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.monitoring-subnet.id
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}
