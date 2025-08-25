variable "env" {
  type    = list(string)
  default = ["dev", "staging", "prod"]
}

variable "project_name" {
  type    = string
  default = "Student-App"
}

variable "bucket_name" {
  type    = string
  default = "vnc-student-app"
}