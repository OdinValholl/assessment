# Define the number of VMs and common configuration variables
variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 2
  validation {
    condition     = var.vm_count >= 2 && var.vm_count <= 100
    error_message = "The vm_count ${var.vm_count} must be between 2 and 100"
  }
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