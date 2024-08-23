variable "project_prefix" {
  type        = string
  default     = "f5xc"
}

# F5XC 

variable "f5xc_api_url"        {}
variable "f5xc_api_token"      {}
variable "f5xc_tenant"         {}

variable "ssh_public_key" {}

# AWS

variable "aws_access_key" {
  type = string
  default = ""
}
variable "aws_secret_key" {
  type = string
  default = ""
}
variable "aws_owner_tag" {
  type = string
  default = ""
}
variable "aws_region" {
  type = string
  default = ""
}
variable "aws_availability_zones" {
  type = list(string)
  default = []
}
variable "aws_ami_name" {
  type = string
}
