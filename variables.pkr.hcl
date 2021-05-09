variable "template_ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "template_ssh_password" {
  type    = string
  default = "ubuntu"
}

variable "template_ssh_key_output_folder" {
  type    = string
  default = "../output/ssh_keys"
}

variable "template_ssh_key_name" {
  type    = string
  default = "id_ed25519_ubuntu_packer"
}

variable "proxmox_username" {
  type    = string
  default = "packer@pve"
}

variable "proxmox_password" {
  type    = string
  default = "toortoor"
}

variable "proxmox_node" {
  type    = string
  default = "proxmox"
}

variable "proxmox_url" {
  type    = string
  default = "https://127.0.0.1:8006/api2/json"
}

variable "proxmox_insecure_skip_tls_verify" {
  type    = bool
  default = false
}

variable "template_name" {
  type    = string
  default = "ubuntu2004"
}
variable "template_description" {
  type    = string
  default = "Ubuntu 20.04 x86_64 template built with packer"
}

variable "template_os" {
  type    = string
  default = "l26"
}

variable "template_iso_file" {
  type    = string
  default = "local:iso/ubuntu-20.04.2-live-server-amd64.iso"
}

variable "template_unmount_iso" {
  type    = bool
  default = true
}

variable "template_memory" {
  type    = string
  default = 1024
}

variable "template_cores" {
  type    = string
  default = 1
}

variable "template_cpu_type" {
  type    = string
  default = "host"
}
variable "tempalte_scsi_controller" {
  type    = string
  default = "virtio-scsi-pci"
}
variable "template_qemu_agent" {
  type    = bool
  default = true
}

variable "template_vga_type" {
  type    = string
  default = "qxl"
}

variable "template_vga_memory" {
  type    = string
  default = 32
}

variable "template_network_model" {
  type    = string
  default = "virtio"
}

variable "template_network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "template_disks_disk_size" {
  type    = string
  default = "10G"
}

variable "template_disks_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "template_disks_storage_pool_type" {
  type    = string
  default = "lvm"
}

variable "template_disks_type" {
  type    = string
  default = "virtio"
}
