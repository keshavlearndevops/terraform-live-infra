variable "db_username" {
  type        = string
  description = "master username for db"
  sensitive   = true
}

variable "db_password" {
  description = "master db password"
  type        = string
  sensitive   = true
}
