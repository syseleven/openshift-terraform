data "openstack_networking_network_v2" "floating_net" {
  count = var.floating_ip ? 1 : 0
  name = var.floating_network
}

resource "openstack_lb_loadbalancer_v2" "loadbalancer" {
  name = var.name_prefix
  vip_network_id = var.network_id
}

resource "openstack_lb_listener_v2" "lb" {
  name            = "${var.name_prefix}-listener"
  protocol        = "TCP"
  protocol_port   = var.tcp_port
  loadbalancer_id = openstack_lb_loadbalancer_v2.loadbalancer.id
}

resource "openstack_lb_pool_v2" "lb" {
  name        = "${var.name_prefix}-pool"
  protocol    = "TCP"
  listener_id = openstack_lb_listener_v2.lb.id
  lb_method   = "ROUND_ROBIN"
}

resource "openstack_lb_monitor_v2" "lb" {
  name        = "${var.name_prefix}-monitor"
  pool_id     = openstack_lb_pool_v2.lb.id
  type        = "TCP"
  timeout     = 1
  delay       = 1
  max_retries = 3
}

resource "openstack_lb_member_v2" "lb" {
  for_each      = var.lb_members
  name          = each.key
  pool_id       = openstack_lb_pool_v2.lb.id
  address       = each.value.internal_ip
  protocol_port = var.tcp_port
}

resource "openstack_networking_floatingip_v2" "loadbalancer" {
  count = var.floating_ip ? 1 : 0
  description = "Floating IP for the Master Load Balancer"
  pool = var.floating_network
}

resource "openstack_networking_floatingip_associate_v2" "loadbalancer" {
  count = var.floating_ip ? 1 : 0
  floating_ip = openstack_networking_floatingip_v2.loadbalancer[0].address
  port_id     = openstack_lb_loadbalancer_v2.loadbalancer.vip_port_id
}
