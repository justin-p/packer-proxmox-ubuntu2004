source "proxmox" "ubuntu20_04" {
  username                 = "${var.proxmox_username}"
  password                 = "${var.proxmox_password}"
  proxmox_url              = "${var.proxmox_url}"
  insecure_skip_tls_verify = "${var.proxmox_insecure_skip_tls_verify}"
  node                     = "${var.proxmox_node}"

  template_name        = "${var.template_name}"
  template_description = "${var.template_description}"
  iso_file             = "${var.template_iso_file}"
  unmount_iso          = "${var.template_unmount_iso}"
  memory               = "${var.template_memory}"
  cores                = "${var.template_cores}"
  cpu_type             = "${var.template_cpu_type}"
  os                   = "${var.template_os}"
  qemu_agent           = "${var.template_qemu_agent}"

  vga {
    type   = "${var.template_vga_type}"
    memory = "${var.template_vga_memory}"
  }

  network_adapters {
    model  = "${var.template_network_model}"
    bridge = "${var.template_network_bridge}"
  }

  disks {
    disk_size         = "${var.template_disks_disk_size}"
    storage_pool      = "${var.template_disks_storage_pool}"
    storage_pool_type = "${var.template_disks_storage_pool_type}"
    type              = "${var.template_disks_type}"
  }

  http_directory = "http"
  boot_wait      = "5s"
  boot_command = [
    "<esc><wait><esc><wait><f6><wait><esc><wait>",
    "<bs><bs><bs><bs><bs>",
    "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
    "--- <enter>"
  ]

  ssh_timeout  = "20m"
  ssh_username = "ubuntu"
  ssh_password = "ubuntu"

}

build {
  sources = ["source.proxmox.ubuntu20_04"]

  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done"
    ]
  }
}
