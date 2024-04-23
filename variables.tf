# This file can declare variables that will be passed to modules.
variable "region" {
  type        = string
  description = "The AWS region to deploy resources into."
  default     = "ca-central-1"
}
