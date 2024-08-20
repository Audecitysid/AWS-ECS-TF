variable "account_id" {
  type        = string
  description = "AWS Account ID"
  default     = "011528303833"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}
