terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-1" {
  name = "sf-project10-vm1"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd8mfc6omiki5govl68h"
      size     = 20
    }
  }

  network_interface {
    ip_address = "10.128.0.41"
    subnet_id  = "e9b641h3qponppitdva6"
    nat        = true
    ipv6       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-2" {
  name = "sf-project10-vm2"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd8mfc6omiki5govl68h"
      size     = 20
    }
  }

  network_interface {
    ip_address = "10.128.0.42"
    subnet_id  = "e9b641h3qponppitdva6"
    nat        = true
    ipv6       = false
  }


  metadata = {


    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-3" {
  name = "sf-project10-vm3"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd8q9honj0ga5pjdkk0u"
      size     = 20
    }
  }

  network_interface {
    ip_address = "10.128.0.43"
    subnet_id  = "e9b641h3qponppitdva6"
    nat        = true
    ipv6       = false
  }

  metadata = {
    ssh-keys = "user:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "local_file" "hosts_ini" {
  content = templatefile("../ansible/hosts.tpl", {
    sf-project10-vm1 = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
    sf-project10-vm2 = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
    sf-project10-vm3 = yandex_compute_instance.vm-3.network_interface.0.nat_ip_address
  })
  filename   = "../ansible/hosts.ini"
  depends_on = [yandex_compute_instance.vm-1, yandex_compute_instance.vm-2, yandex_compute_instance.vm-3]
}

