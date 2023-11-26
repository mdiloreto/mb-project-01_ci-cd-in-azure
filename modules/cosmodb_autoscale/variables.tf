variable "cosmosdb_account_name" {
  type        = string
  default     = null
  description = "Cosmos db account name"
}

variable "cosmosdb_account_location" {
  type        = string
  default     = "eastus"
  description = "Cosmos db account location"
}

variable "cosmosdb_sqldb_name" {
  type        = string
  default     = "default-cosmosdb-sqldb"
  description = "value"
}

variable "sql_container_name" {
  type        = string
  default     = "default-sql-container"
  description = "SQL API container name."
}

variable "max_throughput" {
  type        = number
  default     = 4000
  description = "Cosmos db database max throughput"
  validation {
    condition     = var.max_throughput >= 4000 && var.max_throughput <= 1000000
    error_message = "Cosmos db autoscale max throughput should be equal to or greater than 4000 and less than or equal to 1000000."
  }
  validation {
    condition     = var.max_throughput % 100 == 0
    error_message = "Cosmos db max throughput should be in increments of 100."
  }
}
variable "sql_container_name" {
  
}

variable "create_rg" {
  description = "Variable to decide if its necesary to create RG."
  type = bool
  default = false
}

variable "rg_name" {
  description = "Variable for Resource Name."
}

variable "location" {
  description = "Variable for rg and web app region in azure."
  default = "eastus"
}

variable "name" {
  description = "Variable for the WebApp name."
}