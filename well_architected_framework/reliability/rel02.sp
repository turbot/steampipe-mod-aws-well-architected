locals {
  well_architected_framework_rel02_common_tags = merge(local.well_architected_framework_reliability_common_tags, {
    question_id = "planning-network-topology"
  })
}

benchmark "well_architected_framework_rel02" {
  title       = "REL02 How do you plan your network topology?"
  description = "Workloads often exist in multiple environments. These include multiple cloud environments (both publicly accessible and private) and possibly your existing data center infrastructure. Plans must include network considerations such as intra- and inter-system connectivity, public IP address management, private IP address management, and domain name resolution."
  children = [
    benchmark.well_architected_framework_rel02_rel_planning_network_topology_ha_conn_users,
    benchmark.well_architected_framework_rel02_rel_planning_network_topology_ha_conn_private_networks
  ]

  tags = local.well_architected_framework_rel02_common_tags
}

benchmark "well_architected_framework_rel02_rel_planning_network_topology_ha_conn_users" {
  title       = "BP01 Use highly available network connectivity for your workload public endpoints"
  description = "Building highly available network connectivity to public endpoints of your workloads can help you reduce downtime due to loss of connectivity and improve the availability and SLA of your workload. To achieve this, use highly available DNS, content delivery networks (CDNs), API gateways, load balancing, or reverse proxies."
  // TODO: Review these controls
  children = [
    aws_compliance.control.elb_classic_lb_multiple_az_configured,
    aws_compliance.control.elb_application_gateway_network_lb_multiple_az_configured,
    aws_compliance.control.cloudfront_distribution_waf_enabled,
    aws_compliance.control.cloudfront_distribution_configured_with_origin_failover
  ]

  tags = merge(local.well_architected_framework_rel02_common_tags, {
    choice_id = "rel_planning_network_topology_ha_conn_users"
    severity  = "high"
  })
}

benchmark "well_architected_framework_rel02_rel_planning_network_topology_ha_conn_private_networks" {
  title       = "BP02 Provision redundant connectivity between private networks in the cloud and on-premises environments"
  description = "Use multiple AWS Direct Connect (DX) connections or VPN tunnels between separately deployed private networks. Use multiple DX locations for high availability. If using multiple AWS Regions, ensure redundancy in at least two of them. You might want to evaluate AWS Marketplace appliances that terminate VPNs. If you use AWS Marketplace appliances, deploy redundant instances for high availability in different Availability Zones."
  // TODO: Review these controls
  children = [
    aws_compliance.control.vpc_vpn_tunnel_up
  ]

  tags = merge(local.well_architected_framework_rel02_common_tags, {
    choice_id = "rel_planning_network_topology_ha_conn_private_networks"
    severity  = "high"
  })
}
