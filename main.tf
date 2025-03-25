# Openstack configuration

provider "openstack" {
  domain_name = "default"
  region      = var.region
}

module "keypair" {
  source           = "./modules/keypair"
  cluster_name     = var.cluster_name
  ssh_key_file     = var.ssh_key_file
  ssh_keypair_name = var.ssh_keypair_name
}

module "network" {
  source          = "./modules/network"
  network_name    = "${var.cluster_name}-nodes-net"
  subnet_name     = "${var.cluster_name}-nodes-subnet"
  router_name     = "${var.cluster_name}-router"
  nodes_net_cidr  = var.nodes_net_cidr
  public_net_name = var.public_net_name
  dns_servers     = var.dns_resolver
}

module "openshift-control-secgroup" {
  source       = "./modules/secgroup"
  name_prefix  = "${var.cluster_name}-control"
  rules        = var.openshift_control_secgroup_rules
  icmp_rules   = var.openshift_secgroup_icmp_rules
  range_rules  = var.openshift_secgroup_range_rules
}

module "openshift-worker-secgroup" {
  source       = "./modules/secgroup"
  name_prefix  = "${var.cluster_name}-worker"
  rules        = var.openshift_worker_secgroup_rules
  icmp_rules   = var.openshift_secgroup_icmp_rules
  range_rules  = var.openshift_secgroup_range_rules
}

module "control-nodes" {
  source              = "./modules/nodes"
  node_depends_on     = [module.network.nodes_subnet]
  name_prefix         = "${var.cluster_name}-control"
  nodes_count         = var.control_count
  image_id            = var.image_id
  flavor_name         = var.control_flavor_name
  keypair_name        = module.keypair.keypair_name
  network_name        = module.network.nodes_net_name
  secgroup_name       = module.openshift-control-secgroup.secgroup_name
  assign_floating_ip  = var.worker_assign_floating_ip
  floating_ip_pool    = var.public_net_name
}

module "worker-nodes" {
  source              = "./modules/nodes"
  node_depends_on     = [module.network.nodes_subnet]
  name_prefix         = "${var.cluster_name}-worker"
  nodes_count         = var.worker_count
  image_id            = var.image_id
  flavor_name         = var.worker_flavor_name
  keypair_name        = module.keypair.keypair_name
  network_name        = module.network.nodes_net_name
  secgroup_name       = module.openshift-worker-secgroup.secgroup_name
  assign_floating_ip  = var.worker_assign_floating_ip
  floating_ip_pool    = var.public_net_name
}

module "lb-api" {
  source           = "./modules/loadbalancer"
  name_prefix      = "${var.cluster_name}-lb-api"
  count            = var.enable_loadbalancer ? 1 : 0
  network_id       = module.network.network_id
  tcp_port         = 6443
  floating_ip      = true
  floating_network = var.public_net_name
  lb_members       = length(module.control-nodes.nodes) > 0 ? module.control-nodes.nodes : module.worker-nodes.nodes
}

module "lb-ingress" {
  source           = "./modules/loadbalancer"
  name_prefix      = "${var.cluster_name}-lb-ingress"
  count            = var.enable_loadbalancer ? 1 : 0
  network_id       = module.network.network_id
  tcp_port         = 443
  floating_ip      = true
  floating_network = var.public_net_name
  lb_members       = length(module.worker-nodes.nodes) > 0 ? module.worker-nodes.nodes : module.control-nodes.nodes
}

module "lb-internal" {
  source           = "./modules/loadbalancer"
  name_prefix      = "${var.cluster_name}-lb-internal"
  count            = var.enable_loadbalancer ? 1 : 0
  network_id       = module.network.network_id
  tcp_port         = 22623
  floating_ip      = false
  floating_network = var.public_net_name
  lb_members       = length(module.control-nodes.nodes) > 0 ? module.control-nodes.nodes : module.worker-nodes.nodes
}
