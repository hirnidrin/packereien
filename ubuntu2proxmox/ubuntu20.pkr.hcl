# Hashicorp Packer config to provision an Ubuntu Server 20.04 template onto a Proxmox node.
#
# see
# https://www.packer.io/plugins/builders/proxmox/iso
# https://www.aerialls.eu/posts/ubuntu-server-2004-image-packer-subiquity-for-proxmox/
# https://forum.proxmox.com/threads/using-packer-to-deploy-ubuntu-20-04-to-proxmox.104275/#post-449363

packer {
  required_plugins {
    proxmox = {
      version                 = " >= 1.0.4"
      source                  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "proxmox-ubuntu-20" {

  # Proxmox node settings
  
  node                        = "${var.pm_node}"
  proxmox_url                 = "${var.pm_url}"
  insecure_skip_tls_verify    = true
  username                    = "${var.pm_user}"
  password                    = "${var.pm_pass}"
#  token                       = "${var.pm_token}"
  
  boot_wait                   = "5s"
  http_directory              = "http" # starts a local http server in this dir, serves 'user-data' and 'meta-data' file
  boot_command                = [
    "<esc><wait><esc><wait><f6><wait><esc><wait>",
    "<bs><bs><bs><bs><bs>",
    " autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
    "--- <enter>"
  ] 

  # VM-to-be-created settings
  
  vm_name                     = "packer-ubuntu-20"
  iso_file                    = "local:iso/ubuntu-20.04.4-live-server-amd64.iso"
  unmount_iso                 = true

  template_name               = "packer-ubuntu-20"
  template_description        = <<EOT
  Packer-generated ubuntu-20.04.4-server-amd64
  Login: ${var.ssh_user} / ${var.ssh_pass}
  EOT

  memory                      = 4096
  cores                       = 2
  sockets                     = 1
  os                          = "l26"
  scsi_controller             = "virtio-scsi-pci"
  disks {
    disk_size                 = "20G"
    storage_pool              = "local-lvm"
    storage_pool_type         = "lvm"
  }
  network_adapters {
    bridge                    = "vmbr0"
    model                     = "virtio"
  }
  qemu_agent                  = true

  # VM login, must match one of the users created by ./http/user-data
  # Used by 'packer build .' to determine if provisioning was successful.

  ssh_username                = "${var.ssh_user}"
  ssh_password                = "${var.ssh_pass}"
  ssh_timeout                 = "2h"
  ssh_pty                     = true
  ssh_handshake_attempts      = 20
}

build {
  sources = ["source.proxmox-iso.proxmox-ubuntu-20"]
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "ls /"
    ]
  }
}
