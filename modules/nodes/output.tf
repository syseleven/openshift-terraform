output "associate_floating_ip" {
  value = openstack_compute_floatingip_associate_v2.associate_floating_ip[*]
}

output "nodes" {
  value = { for instance in openstack_compute_instance_v2.instance:
             instance.name =>
                      {"id" = instance.id,
                       "internal_ip" = instance.access_ip_v4} }
}
