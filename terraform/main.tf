terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.179.0"
    }
  }
}

provider "yandex" {
  zone = "ru-central1-a"
}

resource "yandex_compute_disk" "boot-disk-1" {
  name     = "boot-disk-1"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "20"
  image_id = "fd861t36p9dqjfrqm0g4"
}

resource "yandex_compute_disk" "boot-disk-2" {
  name     = "boot-disk-2"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "20"
  image_id = "fd861t36p9dqjfrqm0g4"
}

resource "yandex_compute_instance" "vm-builder" {
  name = "builder"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "serega:${file("/serega/.ssh/id_ed25519.pub")}"
  }
}
resource "yandex_compute_instance" "vm-prod" {
  name = "prod"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-2.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "serega:${file("/serega/.ssh/id_ed25519.pub")}"
  }
}


resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_address_vm-builder" {
  value = yandex_compute_instance.vm-builder.network_interface.0.ip_address
}

output "internal_ip_address_vm-prod" {
  value = yandex_compute_instance.vm-prod.network_interface.0.ip_address
}

output "external_ip_address_vm-builder" {
  value = yandex_compute_instance.vm-builder.network_interface.0.nat_ip_address
}

output "external_ip_address_vm-prod" {
  value = yandex_compute_instance.vm-prod.network_interface.0.nat_ip_address
}