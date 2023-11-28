variable "create_rg" {
  description = "Variable to decide if its necesary to create RG."
  type = bool
  default = false
}

variable "rg_name" {
  description = "Variable for Resource Name."
  default = "madsblog_rg"
}

variable "location" {
  description = "Variable for rg and web app region in azure."
  default = "eastus"
}

variable "webapp_name" {
  description = "Variable for the WebApp name."
}

variable "webapp_count" {
  default = "1"
}

variable "asp_name" {
  default = "mbwebappasp"
  
}