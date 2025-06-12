# variables.tf

variable "student_id" {
  description = "Your Student ID for resource naming."
  type        = string
}

variable "resource_group_name_suffix" {
  description = "Suffix for the resource group name."
  type        = string
  default     = "-p1-rg"
}

variable "location_west_us" {
  description = "Azure region for West US."
  type        = string
  default     = "westus"
}

variable "location_west_europe" {
  description = "Azure region for West Europe."
  type        = string
  default     = "westeurope"
}

variable "personal_ip_range" {
  description = "Your assigned personal IP address range (e.g., 172.16.135.0/24)."
  type        = string
}

variable "vm_admin_username" {
  description = "Administrator username for the Virtual Machines."
  type        = string
}

variable "vm_admin_password" {
  description = "Administrator password for the Virtual Machines."
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = "Size of the Virtual Machines."
  type        = string
  default     = "Standard_B2s"
}

variable "vm_os_publisher" {
  description = "Publisher of the VM OS image."
  type        = string
  default     = "MicrosoftWindowsServer"
}

variable "vm_os_offer" {
  description = "Offer of the VM OS image."
  type        = string
  default     = "WindowsServer"
}

variable "vm_os_sku" {
  description = "SKU of the VM OS image."
  type        = string
  default     = "2019-Datacenter"
}

variable "vm_os_version" {
  description = "Version of the VM OS image."
  type        = string
  default     = "latest"
}

variable "traffic_manager_dns_prefix" {
  description = "DNS prefix for the Azure Traffic Manager profile."
  type        = string
}

variable "project_tag_value" {
  description = "Value for the 'Project' tag."
  type        = string
  default     = "Project1"
}

variable "course_tag_value" {
  description = "Value for the 'Course' tag."
  type        = string
  default     = "CLO800"
}
