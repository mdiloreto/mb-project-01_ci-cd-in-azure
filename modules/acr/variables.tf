variable "create_rg" {
  description = "Variable to decide if its necesary to create RG."
  type = bool
  default = false
}

variable "rg_name" {
  description = "Variable for Resource Name."
}

variable "location" {
  description = "Variable for rg in azure."
  default = "eastus"
}

variable "name" {
  description = "Variable for the  name."
}