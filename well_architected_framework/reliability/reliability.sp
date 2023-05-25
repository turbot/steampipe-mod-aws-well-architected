locals {
  well_architected_framework_reliability_common_tags = merge(local.well_architected_framework_common_tags, {
    pillar = "reliability"
  })
}

locals {
  well_architected_framework_reliability_1_common_tags = merge(local.well_architected_framework_reliability_common_tags, {
    question_id = "manage-service-limits"
  })
  well_architected_framework_reliability_2_common_tags = merge(local.well_architected_framework_reliability_common_tags, {
    question_id = "planning-network-topology"
  })
}


benchmark "well_architected_framework_reliability" {
  title       = "Reliability Pillar"
  description = "The reliability pillar focuses on workloads performing their intended functions and how to recover quickly from failure to meet demands. Key topics include distributed system design, recovery planning, and adapting to changing requirements."
  children = [
    benchmark.well_architected_framework_reliability_1,
    benchmark.well_architected_framework_reliability_2
  ]

  tags = local.well_architected_framework_reliability_common_tags
}

benchmark "well_architected_framework_reliability_1" {
  title       = "REL 1: How do you manage service quotas and constraints?"
  description = "For cloud-based workload architectures, there are service quotas (which are also referred to as service limits). These quotas exist to prevent accidentally provisioning more resources than you need and to limit request rates on API operations so as to protect services from abuse. There are also resource constraints, for example, the rate that you can push bits down a fiber-optic cable, or the amount of storage on a physical disk."
  children = [
    benchmark.well_architected_framework_reliability_1_rel_manage_service_limits_aware_quotas_and_constraints,
    benchmark.well_architected_framework_reliability_1_rel_manage_service_limits_limits_considered
  ]

  tags = local.well_architected_framework_reliability_1_common_tags
}


benchmark "well_architected_framework_reliability_1_rel_manage_service_limits_aware_quotas_and_constraints" {
  title       = "Aware of service quotas and constraints"
  description = "Be aware of your default quotas and manage your quota increase requests for your workload architecture. Know which cloud resource constraints, such as disk or network, are potentially impactful."
  // TODO: Review these controls
  children = [
    aws_compliance.control.lambda_function_concurrent_execution_limit_configured,
    aws_compliance.control.lambda_function_dead_letter_queue_configured
  ]

  tags = merge(local.well_architected_framework_reliability_1_common_tags, {
    choice_id = "rel_manage_service_limits_aware_quotas_and_constraints"
    severity  = "high"
  })
}

benchmark "well_architected_framework_reliability_1_rel_manage_service_limits_limits_considered" {
  title       = "Manage service quotas across accounts and Regions"
  description = "If you are using multiple accounts or Regions, request the appropriate quotas in all environments in which your production workloads run."
  // TODO: Review these controls
  children = [
    aws_compliance.control.lambda_function_concurrent_execution_limit_configured,
    aws_compliance.control.lambda_function_dead_letter_queue_configured
  ]

  tags = merge(local.well_architected_framework_reliability_1_common_tags, {
    choice_id = "rel_manage_service_limits_limits_considered"
    severity  = "high"
  })
}

benchmark "well_architected_framework_reliability_2" {
  title       = "REL 2: How do you plan your network topology?"
  description = "Workloads often exist in multiple environments. These include multiple cloud environments (both publicly accessible and private) and possibly your existing data center infrastructure. Plans must include network considerations such as intra- and inter-system connectivity, public IP address management, private IP address management, and domain name resolution."
  children = [
    benchmark.well_architected_framework_reliability_2_rel_planning_network_topology_ha_conn_users,
    benchmark.well_architected_framework_reliability_2_rel_planning_network_topology_ha_conn_private_networks
  ]

  tags = local.well_architected_framework_reliability_2_common_tags
}

benchmark "well_architected_framework_reliability_2_rel_planning_network_topology_ha_conn_users" {
  title       = "Use highly available network connectivity for your workload public endpoints"
  description = "Building highly available network connectivity to public endpoints of your workloads can help you reduce downtime due to loss of connectivity and improve the availability and SLA of your workload. To achieve this, use highly available DNS, content delivery networks (CDNs), API gateways, load balancing, or reverse proxies."
  // TODO: Review these controls
  children = [
    aws_compliance.control.elb_classic_lb_multiple_az_configured,
    aws_compliance.control.elb_application_gateway_network_lb_multiple_az_configured,
    aws_compliance.control.cloudfront_distribution_waf_enabled,
    aws_compliance.control.cloudfront_distribution_configured_with_origin_failover
  ]

  tags = merge(local.well_architected_framework_reliability_2_common_tags, {
    choice_id = "rel_planning_network_topology_ha_conn_users"
    severity  = "high"
  })
}

benchmark "well_architected_framework_reliability_2_rel_planning_network_topology_ha_conn_private_networks" {
  title       = "Provision redundant connectivity between private networks in the cloud and on-premises environments"
  description = "Use multiple AWS Direct Connect (DX) connections or VPN tunnels between separately deployed private networks. Use multiple DX locations for high availability. If using multiple AWS Regions, ensure redundancy in at least two of them. You might want to evaluate AWS Marketplace appliances that terminate VPNs. If you use AWS Marketplace appliances, deploy redundant instances for high availability in different Availability Zones."
  // TODO: Review these controls
  children = [
    aws_compliance.control.vpc_vpn_tunnel_up
  ]

  tags = merge(local.well_architected_framework_reliability_2_common_tags, {
    choice_id = "rel_planning_network_topology_ha_conn_private_networks"
    severity  = "high"
  })
}
