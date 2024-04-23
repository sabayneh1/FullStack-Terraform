variable "subnets" {
  type        = list(string)
  description = "A list of subnet IDs to associate with the Auto Scaling Group."
}

variable "image_id" {
  type        = string
  description = "The AMI ID to use for the EC2 instances."
}

variable "instance_type" {
  type        = string
  description = "The type of EC2 instance to use."
}

variable "min_size" {
  type        = number
  description = "Minimum size of the Auto Scaling Group."
}

variable "max_size" {
  type        = number
  description = "Maximum size of the Auto Scaling Group."
}

variable "key_name" {
  type        = string
  description = "The key name to use for the EC2 instances."
}


variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "target_group_arn" {
  description = "ARN of the target group to which the ASG instances should be attached"
}

variable "db_host" {
  type        = string
  description = "db_instance_address"
}


variable "db_security_group_id" {
  type        = string
  description = "Security Group ID for the database"
}
