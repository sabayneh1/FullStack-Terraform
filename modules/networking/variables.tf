variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "A list of CIDR blocks for the public subnets."
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "A list of CIDR blocks for the private subnets."
}

variable "azs" {
  type        = list(string)
  description = "A list of availability zones in which to create subnets."
}
