####################
# Global variables #
####################

variable "region" {
  type        = string
  description = "Openstack region to launch servers."
  default     = null
}

variable "cluster_name" {
  type        = string
  default     = "openshift"
  description = "Name of the cluster"
}

variable "ssh_keypair_name" {
  type        = string
  default     = null
  description = "SSH keypair name"
}

variable "ssh_key_file" {
  type        = string
  default     = "sshkeys.pub"
  description = "Local path to SSH key"
}

variable "image_id" {
  type        = string
  default     = "$IMAGE_ID"
  description = "Openshift image id"
}

######################
# Secgroup variables #
######################

variable "openshift_control_secgroup_rules" {
  type = list(any)
  default = [{ "source" = "0.0.0.0/0", "protocol" = "tcp", "portmin" = 6443, "portmax" = 6443 },
    { "source" = "0.0.0.0/0", "protocol" = "tcp", "portmin" = 443, "portmax" = 443 },
    { "source" = "0.0.0.0/0", "protocol" = "tcp", "portmin" = 22, "portmax" = 22 },
  ]
  description = "Security group rules"
}

variable "openshift_worker_secgroup_rules" {
  type = list(any)
  default = [{ "source" = "0.0.0.0/0", "protocol" = "tcp", "portmin" = 22, "portmax" = 22 },
    { "source" = "0.0.0.0/0", "protocol" = "tcp", "portmin" = 443, "portmax" = 443 },
  ]
  description = "Security group rules"
}

variable "openshift_secgroup_range_rules" {
  type = list(any)
  default = [{ "source" = "10.129.14.0/24", "ethertype" = "IPv4", "protocol" = "tcp", "port_min" = 30000, "port_max" = 32767 },
    { "source" = "10.129.14.0/24", "ethertype" = "IPv4", "protocol" = "icmp", "port_min" = 0, "port_max" = 0 },
  ]
  description = "Security group rules"
}

variable "openshift_secgroup_icmp_rules" {
  type = list(any)
  default = [{ "source" = "0.0.0.0/0", "protocol" = "icmp" },
  ]
  description = "Security group icmp rules"
}

#####################
# Network variables #
#####################

variable "nodes_net_cidr" {
  type        = string
  default     = "10.129.14.0/24"
  description = "Network CIDR"
}

variable "public_net_name" {
  type        = string
  default     = "ext-net"
  description = "External network name"
}

variable "dns_resolver" {
  type        = list(string)
  default     = ["37.123.105.116", "37.123.105.117"]
  description = "Openstack dns resolver"
}

variable "enable_loadbalancer" {
  type        = bool
  default     = true
  description = "Enable Octavia LB nodes"
}

###########################
# Control Plane variables #
###########################

variable "control_count" {
  type        = number
  default     = 3
  description = "Number of deploy nodes"
}

variable "control_flavor_name" {
  type        = string
  default     = "m2.medium"
  description = "Deploy node flavor name"
}

variable "control_assign_floating_ip" {
  type    = string
  default = "true"
}

###########################
# Worker Node variables   #
###########################

variable "worker_count" {
  type        = number
  default     = 3
  description = "Number of deploy nodes"
}

variable "worker_flavor_name" {
  type        = string
  default     = "m2.medium"
  description = "Deploy node flavor name"
}

variable "worker_assign_floating_ip" {
  type    = string
  default = "true"
}
