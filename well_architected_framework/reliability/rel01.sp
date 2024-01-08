locals {
  well_architected_framework_rel01_common_tags = merge(local.well_architected_framework_reliability_common_tags, {
    question_id = "manage-service-limits"
  })
}

benchmark "well_architected_framework_rel01" {
  title       = "REL01 How do you manage service quotas and constraints?"
  description = "For cloud-based workload architectures, there are service quotas (which are also referred to as service limits). These quotas exist to prevent accidentally provisioning more resources than you need and to limit request rates on API operations so as to protect services from abuse. There are also resource constraints, for example, the rate that you can push bits down a fiber-optic cable, or the amount of storage on a physical disk."
  children = [
    benchmark.well_architected_framework_rel01_bp03
  ]

  tags = local.well_architected_framework_rel01_common_tags
}


benchmark "well_architected_framework_rel01_bp03" {
  title       = "BP03 Accommodate fixed service quotas and constraints through architecture"
  description = "Be aware of unchangeable service quotas, service constraints, and physical resource limits. Design architectures for applications and services to prevent these limits from impacting reliability."
  children = [
    aws_compliance.control.lambda_function_concurrent_execution_limit_configured
  ]

  tags = merge(local.well_architected_framework_rel01_common_tags, {
    choice_id = "rel_manage_service_limits_aware_fixed_limits"
    risk  = "medium"
  })
}
