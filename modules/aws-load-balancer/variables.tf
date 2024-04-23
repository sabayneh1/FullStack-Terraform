variable "name" {
  description = "The name of the load balancer"
  type        = string
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the Load Balancer"
  type        = list(string)
}

variable "security_groups" {
  description = "A list of security group IDs to assign to the Load Balancer"
  type        = list(string)
}

variable "internal" {
  description = "Indicates if the LB should be internal"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The VPC ID where the load balancer and other resources will be created"
  type        = string
}

variable "web_instance_id" {
  description = "The ID of the web instance to attach to the target group"
  type        = string
}

variable "ssl_certificate_arn" {
  description = "The ARN of the SSL certificate in AWS ACM"
  default     = "arn:aws:acm:ca-central-1:247867391235:certificate/9abc7a64-1f5c-4d73-b8fb-c601b9f1e654"
}



