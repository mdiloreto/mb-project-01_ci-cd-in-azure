variable "rg_name" {
  description = "The name of the resource group."
  type        = string
}

variable "name" {
  description = "The name of the webhook."
  type        = string
}

variable "acr_name" {
  description = "The name of the Azure Container Registry."
  type        = string
}

variable "location" {
  description = "The location/region of the resources."
  type        = string
}

variable "service_uri" {
  description = "The service URI for the webhook."
  type        = string
}

variable "status" {
  description = "The status of the webhook."
  type        = string
}

variable "scope" {
  description = "The scope of repositories for which the webhook gets triggered."
  type        = string
}

variable "action" {
  description = "The action that triggers the webhook."
  type        = string
}
