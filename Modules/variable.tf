
variable "vm_size" {
  type    = string
  default = "Standard_B2ms"
}
variable "storage_account_name" {
  type    = string
  default = "webappstorage"
}

variable "public_ip_name" {
  type    = string
  default = "webapp-publicip"
}


variable "stage" {
  type    = string
  default = "module"
}
variable "network_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "location" {
  type    = string
  default = "West Europe"
}

variable "prefix" {
  type    = string
  default = "sule123"
}