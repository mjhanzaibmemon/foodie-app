variable "name" { type = string }
variable "vpc_id" { type = string }
variable "db_port" {
  type    = number
  default = 3306
}
variable "ingress_cidrs" {
  type    = list(string)
  default = []
}
