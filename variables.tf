# Define the number of VMs and common configuration variables
variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 1
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "resource-group"
}

variable "location" {
  description = "Azure region location"
  type        = string
  default     = "westeurope"
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "subnet"
}

variable "vm_size" {
  description = "Size of the VMs"
  type        = string
  default     = "Standard_B2s"
}