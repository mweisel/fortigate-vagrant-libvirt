variable "version" {
  type    = string
  default = "unknown"
}

variable "gui_disabled" {
  type    = bool
  default = true
}

variable "boot_time" {
  type    = string
  default = "1m"
}

variable "boot_key_interval" {
  type    = string
  default = "50ms"
}

variable "out_dir" {
  type    = string
  default = "tmp_out"
}

source "qemu" "fortigate" {
  accelerator       = "kvm"
  cpus              = 1
  memory            = 1024
  skip_resize_disk  = true
  skip_compaction   = true
  disk_image        = true
  use_backing_file  = false
  disk_interface    = "virtio"
  disk_cache        = "none"
  format            = "qcow2"
  net_device        = "virtio-net"
  iso_checksum      = "none"
  iso_url           = "/var/lib/libvirt/images/fortios.qcow2"
  boot_wait         = "${var.boot_time}"
  boot_key_interval = "${var.boot_key_interval}"
  boot_command = [
    "admin<enter><wait>",
    "<enter><wait>",
    "admin<enter><wait>",
    "admin<enter><wait>",
    "config system admin<enter><wait>",
    "edit vagrant<enter><wait>",
    "set accprofile super_admin<enter><wait>",
    "set password vagrant<enter><wait>",
    "set ssh-public-key1 \"ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==\"<enter><wait>",
    "end<enter><wait>",
    "config system interface<enter><wait>",
    "edit port1<enter><wait>",
    "set allowaccess ping http ssh fgfm snmp<enter><wait>",
    "end<enter><wait>",
    "config system global<enter><wait>",
    "set admintimeout 60<enter><wait>",
    "set admin-ssh-grace-time 3600<enter><wait>",
    "end<enter><wait>",
    "execute shutdown<enter><wait>",
    "y<enter><wait>"
  ]
  headless         = "${var.gui_disabled}"
  communicator     = "none"
  vm_name          = "fgt-${var.version}"
  output_directory = "${var.out_dir}"
}

build {
  sources = ["source.qemu.fortigate"]

  post-processor "vagrant" {
    vagrantfile_template = "src/Vagrantfile"
    output               = "builds/fortinet-fortigate-${var.version}.box"
  }
}
