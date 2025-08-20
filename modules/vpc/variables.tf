variable "vpc_cidrs" {
  type = map(string)
  default = {
    "Bastion-VPC" = "12.20.0.0/16"
    "Main-VPC"    = "12.24.0.0/16"
  }
}

variable "env" {
  type    = list(string)
  default = ["dev", "staging", "prod"]
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "bastion_pub_sub_cidr" {
  type    = string
  default = "12.20.1.0/24"
}

variable "all_traffic_internet" {
  type    = string
  default = "0.0.0.0/0"
}

variable "main_sub_cidr" {
  type = map(string)
  default = {
    "pub_cidr" = "12.24.2.0/24"
    "pvt_cidr" = "12.24.4.0/24"
  }
}