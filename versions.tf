terraform {
  required_version = ">= 1.10.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "2.0.0"
    }
  }
}
