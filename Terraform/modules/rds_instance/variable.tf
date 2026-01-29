variable "identifier" { type = string }
variable "engine_version" { type = string }
variable "instance_class" { type = string }

variable "username" { type = string }
variable "password" {
  type      = string
  sensitive = true
}
variable "db_name" { type = string }

variable "allocated_storage" {
  type = number
}
variable "max_allocated_storage" {
  type = number
}
variable "storage_type" {
  type = string

}

variable "db_subnet_group_name" { type = string }
variable "sg_id" { type = string }
