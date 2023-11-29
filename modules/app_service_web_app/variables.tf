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

variable "docker_image_main" {
  description = "image name like <acrName>.azurecr.io/<imageName>:<tag>"
  
}

variable "docker_image_dev" {
  description = "image name like <acrName>.azurecr.io/<imageName>:<tag>"
  
}

variable "acr_url" {}
variable "docker_image_main_tag" {}
variable "docker_image_dev_tag" {}

variable "webapp_sa_acc_name" {
  description = "The name of the storage account."
  type        = string
}

variable "webapp_sa_access_key" {
  description = "The access key for the storage account."
  type        = string
  sensitive   = true
}

variable "webapp_sa_name" {
  description = "The name for the storage account service."
  type        = string
}

variable "webapp_sa_share_name_main" {
  description = "The name of the storage account file share."
  type        = string
  default = "main"
}

variable "webapp_sa_share_name_dev" {
  description = "The name of the storage account file share."
  type        = string
  default = "dev"
}

variable "webapp_sa_type" {
  description = "The type of the storage account to mount."
  type        = string
}

variable "webapp_sa_mount_path" {
  description = "The mount path for the storage account."
  type        = string
}
