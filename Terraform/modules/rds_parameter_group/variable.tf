variable "name" { type = string }
variable "family" { type = string }
variable "parameters" {
  type    = map(string)
  default = {}
}
