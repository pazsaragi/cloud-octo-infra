variable "rds_username" {
  description = "The username for the RDS instance. Cannot be admin."
}

variable "rds_password" {
  description = "RDS Password"
}

variable "apigateway_secret" {
  description = "The API Gateway Secret"
}

variable "db_name" {
  description = "The name of the database"
}

variable "debug" {
  description = "Debug mode"
  default     = true
}

variable "allowed_hosts" {
  description = "Allowed hosts"
  default     = "['*']"
}

variable "public_key" {}
