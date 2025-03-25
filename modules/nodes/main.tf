resource "openstack_compute_instance_v2" "instance" {
  depends_on              = [var.node_depends_on]
  count                   = var.nodes_count
  name                    = "${var.name_prefix}${format("%01d", count.index+1)}"
  flavor_name             = var.flavor_name
  key_pair                = var.keypair_name

  network {
    name = var.network_name
  }

  # boot device
  block_device {
    source_type           = "blank"
    volume_size           = "100"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = false
  }

  # cd-rom
  block_device {
    uuid             = var.image_id
    source_type      = "image"
    destination_type = "volume"
    boot_index       = 1
    volume_size      = 5
    device_type      = "cdrom"
  }

  metadata = {
    Group  = var.name_prefix
    name   = format("%s%01d", var.name_prefix, count.index)
  }

  security_groups = [var.secgroup_name,var.secgroup_default]

  lifecycle {
    create_before_destroy = true
    ignore_changes = [flavor_name,image_name]
  }
}

resource "openstack_networking_floatingip_v2" "floating_ip" {
  count = var.assign_floating_ip ? var.nodes_count : 0
  pool  = var.floating_ip_pool
}

resource "openstack_compute_floatingip_associate_v2" "associate_floating_ip" {
  count       = var.assign_floating_ip ? var.nodes_count : 0
  floating_ip = openstack_networking_floatingip_v2.floating_ip[count.index].address
  instance_id = openstack_compute_instance_v2.instance[count.index].id
}
