resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = "${var.name_prefix}-secgroup"
  description = "Security group for Servers"
}

resource "openstack_networking_secgroup_rule_v2" "default_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.secgroup.id
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "rules" {
  for_each          = {
    for rule in var.rules :
    format("%s-%s-%s-%s", rule["source"], rule["protocol"], rule["portmin"], rule["portmax"]) => rule
  }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = each.value.protocol
  port_range_min    = each.value.portmin
  port_range_max    = each.value.portmax
  remote_ip_prefix  = each.value.source
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "icmp_rules" {
  for_each          = {
    for rule in var.icmp_rules :
    format("%s-%s", rule["source"], rule["protocol"]) => rule
  }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = each.value.protocol
  remote_ip_prefix  = each.value.source
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "range_rules" {
  for_each          = {
    for rule in var.range_rules :
    format("%s-%s-%s-%s-%s", rule["source"], rule["ethertype"], rule["protocol"], rule["port_min"], rule["port_max"]) => rule
  }
  direction         = "ingress"
  ethertype         = each.value.ethertype
  protocol          = each.value.protocol
  port_range_min    = each.value.port_min
  port_range_max    = each.value.port_max
  remote_ip_prefix  = each.value.source
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}
