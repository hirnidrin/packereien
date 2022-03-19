variable "pm_node" {
  type        = string
  description = "Proxmox node"
  default     = "pve"
}
variable "pm_url" {
  type        = string
  description = "Proxmox API URL"
  default     = "https://192.168.yyy.zzz:8006/api2/json"
}

variable "pm_user" {
  type        = string
  description = "Proxmox user with API permissions"
  default     = "packer@pve"
}
variable "pm_pass" {
  type        = string
  description = "Proxmox user password"
  default     = "packer"
}
variable "pm_token" {
  type        = string
  description = "Proxmox API token, might use instead of password"
  default     = "dummy"
}

variable "ssh_user" {
  type        = string
  description = "VM SSH user, must match an user created in ./http/user-data"
  default     = "ubuntu"
}
variable "ssh_pass" {
  type        = string
  description = "VM SSH user password"
  default     = "ubuntu"
}
