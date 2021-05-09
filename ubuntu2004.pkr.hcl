## Dummy source that enables us to run the ansible pre-provisioning.
source "null" "ansible-pre-provisioning" {
  communicator = "none"
}

## Run ansible pre-provisioning playbook.
build {
  sources = ["source.null.ansible-pre-provisioning"]
  provisioner "ansible" {
    playbook_file = "${path.root}/playbooks/pre-provisioning.yml"
    extra_arguments = [
      "--extra-vars",
      "user='${var.template_ssh_username}' password='${var.template_ssh_password}' ssh_folder='${var.template_ssh_key_output_folder}' ssh_key_name='${var.template_ssh_key_name}'"
    ]
  }
}

## Define proxmox Ubuntu 20.04 template.
source "proxmox" "ubuntu2004" {
  username                 = "${var.proxmox_username}"
  password                 = "${var.proxmox_password}"
  proxmox_url              = "${var.proxmox_url}"
  insecure_skip_tls_verify = "${var.proxmox_insecure_skip_tls_verify}"
  node                     = "${var.proxmox_node}"

  template_name        = "${var.template_name}"
  template_description = "${var.template_description}"
  os                   = "${var.template_os}"
  iso_file             = "${var.template_iso_file}"
  unmount_iso          = "${var.template_unmount_iso}"
  memory               = "${var.template_memory}"
  cores                = "${var.template_cores}"
  cpu_type             = "${var.template_cpu_type}"
  scsi_controller      = "${var.tempalte_scsi_controller}"
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

  http_directory = "output/http"
  boot_wait      = "5s"
  boot_command = [
    "<esc><wait><esc><wait><f6><wait><esc><wait>",
    "<bs><bs><bs><bs><bs>",
    "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
    "--- <enter>"
  ]

  ssh_timeout  = "20m"
  ssh_username = "${var.template_ssh_username}"
  ssh_password = "${var.template_ssh_password}"
}

# Build proxmox Ubuntu 20.04 template and wait for cloud-init to finish.
build {
  sources = ["source.proxmox.ubuntu2004"]

  provisioner "shell" {
    inline = [
      "echo 'Waiting for cloud-init...'",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done"
    ]
  }

  provisioner "ansible" {
    playbook_file = "${path.root}/playbooks/post-provisioning.yml"
  }
}
