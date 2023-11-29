variable "repo_name" {
  default = "app"
}

variable "description" {
  default = "my app repo"
}

variable "source_dir" {
  description = "The directory containing the source files to be copied"
  type        = string
  default     = "C:\\nginx_app"
}

variable "repo_dir" {
  description = "The directory where the repository is cloned"
  type        = string
  default     = "C:\\Users\\mdiloreto\\app"
}

variable "repo_url" {
  description = "The URL of the git repository"
  type        = string
  default     = "https://github.com/mdiloreto/app"
}
