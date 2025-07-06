variable "VM_Name"{
    default ="sqlvm"
}
variable "NIC_Name"{
    default ="SQL-NIC"
}

variable "username" {
  default     = "SOliTechAdmin"
}
variable "admin_password" {
	description = "The admin password for the VM"
	type        = string
	sensitive   = true
}
