# Provider
provider "aws" {
  region     = "${var.region}"
}
# General
data "aws_caller_identity" "current" {}
variable "resource-name" {
    default = "test"
}
# AWS
variable "region" {
  default = "ap-northeast-1"
}