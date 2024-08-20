variable "account_id" {
  type        = string
  description = "AWS Account ID"
  default     = "011528303833"
}

variable "env" {
  description = "Environment name"
  default     = "dev"
}

variable "project" {
  description = "Project name"
}

variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}
