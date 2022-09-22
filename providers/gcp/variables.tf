variable "vpc_name" {
    type = string
    default = "vpc-network"
    description = "Vpc name"
}
variable "project" {}

variable "credentials_file" {}

variable "region" {
  type = string
  default = "us-central1"
}

variable "zone" {
  type = string
  default = "us-central1-a"
}