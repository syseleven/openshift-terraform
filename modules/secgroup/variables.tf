variable "name_prefix" {
  type = string
}

variable "rules" {
  type = list
}

variable "range_rules" {
  type = list
}

variable "icmp_rules" {
  type = list
}

variable "default_secgroup" {
  type = string
  default = "default"
}
