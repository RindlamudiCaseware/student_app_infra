variable "instance_name" {
  type    = string
  default = "dev-student-app"
}
variable "ami_name" {
  type    = list(string)
  default = ["ami-00ca32bbc84273381"]
}
variable "instance_typ" {
  type    = list(string)
  default = ["t2.micro", "t2.small"]
}
variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
variable "key_name" {
  type    = string
  default = "vnc"
}
variable "vol_size" {
  type    = list(number)
  default = [15, 28]
}
variable "vol_type" {
  type    = string
  default = "gp3"
}
variable "device_name" {
  type    = string
  default = "/dev/xvda"
}
variable "env" {
  type    = list(string)
  default = ["dev", "staging", "prod"]
}