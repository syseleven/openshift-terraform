output "floating_ip" {
  value = var.floating_ip ? openstack_networking_floatingip_v2.loadbalancer[0].address : null
}
