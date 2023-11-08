##--Connects Cloud Cloud Provider and other Terraform drivers/modules
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.84.0"
    }
  }
}

##--Defines Local Variables
variable "yc_token" { type=string }

locals {
  ## generates auth-token (with 12h lifespan)
  ## $ export TF_VAR_yc_token=$(yc iam create-token) && echo $TF_VAR_yc_token
  #
  iam_token        = "${var.yc_token}"
  cloud_id         = "b1g0u201bri5ljle0qi2"
  folder_id        = "b1gqi8ai4isl93o0qkuj"
  access_zone      = "ru-central1-b"
  netw_name        = "acme-net"
  net_id           = "enpjul7bs1mq29s7m5gf"
  net_sub_name     = "acme-net-sub1"
  net_sub_id       = "e2lcqv479p4bicmd33i1"
  vm_default_login = "ubuntu"
  ssh_keys_dir     = "/home/devops/.ssh"
  ssh_pubkey_path  = "/home/devops/.ssh/id_ed25519.pub"
  ssh_privkey_path = "/home/devops/.ssh/id_ed25519"
  vm1_name         = "srv1"
  vm1_hostname     = "srv1"
  vm1_ipv4_local   = "10.0.10.13"
  vm1_disk0size    = 8
  vm2_name         = "srv2"
  vm2_hostname     = "srv2"
  vm2_ipv4_local   = "10.0.10.14"
  vm2_disk0size    = 8
}

##--Connects to Cloud with Cloud ids
provider "yandex" {
  token     = local.iam_token
  cloud_id  = local.cloud_id
  folder_id = local.folder_id
  zone      = local.access_zone
}

##----------------------------------------------------------------------------------------
##--Creates VM1 (Ubuntu 22.04, x2 vCPU, x2 GB RAM, x8 GB HDD) -- srv1.dotspace.ru
resource "yandex_compute_instance" "srv1" {
  name        = local.vm1_name
  hostname    = local.vm1_hostname
  platform_id = "standard-v2"
  zone        = local.access_zone

  ## Sets CPU, CPU fraction, Memory values
  resources {
    cores         = 2
    core_fraction = 5
    memory        = 2
  }

  ## Sets VM interruptible by Cloud technical tasks (makes VM 50% cheaper)
  scheduling_policy {
    preemptible = true
  }

  ## Sets Boot disk configuration
  boot_disk {
    initialize_params {
      image_id    = "fd8clogg1kull9084s9o"
      type        = "network-hdd"
      size        = local.vm1_disk0size
      description = "Ubuntu 22.04 LTS"
    }
  }

  ## Sets Network interface configuration
  network_interface {
    #subnet_id  = yandex_vpc_subnet.subnet1.id
    subnet_id   = local.net_sub_id
    ip_address  = local.vm1_ipv4_local
    nat         = true
  }

  ## Sets OS User authentication parameters
  metadata = {
    serial-port-enable = 0
    ssh-keys = "ubuntu:${file("${local.ssh_pubkey_path}")}"
    #ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }

  ## Copies files #1
  ## Copies ssh-key directory from local host to remote VM (for further "devops" user configuration)
  provisioner "file" {
    #source     = "/home/devops/.ssh/"
    source      = local.ssh_keys_dir
    destination = "/tmp"

    #..provisioner ssh connection parameters (important)
    connection {
      type = "ssh"
      user = "ubuntu"
      host = yandex_compute_instance.srv1.network_interface.0.nat_ip_address
      agent = false
      private_key = file(local.ssh_privkey_path)
      #private_key = file("/home/devops/.ssh/id_ed25519")
      timeout = "3m"
    }
  }

  ## Copies files #1
  ## Copies shell scripts and configuration files from local host to remote VM
  provisioner "file" {
    source      = "scripts/srv1"
    destination = "/home/ubuntu/scripts/"

    #..provisioner ssh connection parameters (important)
    connection {
      type = "ssh"
      user = "ubuntu"
      host = yandex_compute_instance.srv1.network_interface.0.nat_ip_address
      agent = false
      private_key = file(local.ssh_privkey_path)
      timeout = "4m"
    }
  }

  ## Executes master shell-script on remote VM after VM becomes available online
  ## *master script executes other scripts
  provisioner "remote-exec" {
    #..provisioner ssh connection parameters (important)
    connection {
      type = "ssh"
      user = "ubuntu"
      host = yandex_compute_instance.srv1.network_interface.0.nat_ip_address
      agent = false
      private_key = file(local.ssh_privkey_path)
      timeout = "4m"
    }
    ##..shell command execution block (1 command executes per 1 ssh connection)
    inline = [
      "chmod +x /home/ubuntu/scripts/configure_00-main.sh",
      "/home/ubuntu/scripts/configure_00-main.sh"
    ]

  } ## << "provisioner remote-exec"

}


##----------------------------------------------------------------------------------------
##--Creates VM2 (Ubuntu 22.04, x2 vCPU, x2 GB RAM, x8 GB HDD) -- srv2.dotspace.ru
resource "yandex_compute_instance" "srv2" {
  name        = local.vm2_name
  hostname    = local.vm2_hostname
  platform_id = "standard-v2"
  zone        = local.access_zone

  resources {
    cores         = 2
    core_fraction = 5
    memory        = 2
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id    = "fd8clogg1kull9084s9o"
      type        = "network-hdd"
      size        = local.vm2_disk0size
      description = "Ubuntu 22.04 LTS"
    }
  }

  network_interface {
    subnet_id   = local.net_sub_id
    ip_address  = local.vm2_ipv4_local
    nat         = true
  }

  metadata = {
    serial-port-enable = 0
    ssh-keys = "ubuntu:${file("${local.ssh_pubkey_path}")}"
  }

  provisioner "file" {
    source      = local.ssh_keys_dir
    destination = "/tmp"

    connection {
      type = "ssh"
      user = "ubuntu"
      host = yandex_compute_instance.srv2.network_interface.0.nat_ip_address
      agent = false
      private_key = file(local.ssh_privkey_path)
      timeout = "3m"
    }
  }

  provisioner "file" {
    source      = "scripts/srv2"
    destination = "/home/ubuntu/scripts/"

    connection {
      type = "ssh"
      user = "ubuntu"
      host = yandex_compute_instance.srv2.network_interface.0.nat_ip_address
      agent = false
      private_key = file(local.ssh_privkey_path)
      timeout = "4m"
    }
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      host = yandex_compute_instance.srv2.network_interface.0.nat_ip_address
      agent = false
      private_key = file(local.ssh_privkey_path)
      timeout = "4m"
    }
    inline = [
      "chmod +x /home/ubuntu/scripts/configure_00-main.sh",
      "/home/ubuntu/scripts/configure_00-main.sh"
    ]

  } ## << "provisioner remote-exec"

}
