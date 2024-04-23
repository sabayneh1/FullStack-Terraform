variable "db_instance_type" {
  type        = string
  description = "The instance type of the RDS instance."
}

variable "db_name" {
  type        = string
  description = "The name of the database."
  default     = "mydb"
}

variable "db_user" {
  type        = string
  description = "The username for the database."
}

variable "db_password" {
  type        = string
  description = "The password for the database."
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs for the DB subnet group."
}


variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "web_security_group_id" {
  type        = string
  description = "Security Group ID for the web instances"
}
