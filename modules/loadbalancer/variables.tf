variable "name_prefix" {
  type = string
}

variable "network_id" {
}

variable "tcp_port" {
}

variable "floating_network" {
  type = string
}

variable "floating_ip" {
  type = string
}

variable "lb_members" {
  type = map(map(string))
}
