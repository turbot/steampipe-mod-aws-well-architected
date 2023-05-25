locals {
  well_architected_framework_rel01_common_tags = merge(local.well_architected_framework_reliability_common_tags, {
    question_id = "manage-service-limits"
  })
}

benchmark "well_architected_framework_rel01" {
  title       = "REL01 How do you manage service quotas and constraints?"
  description = "For cloud-based workload architectures, there are service quotas (which are also referred to as service limits). These quotas exist to prevent accidentally provisioning more resources than you need and to limit request rates on API operations so as to protect services from abuse. There are also resource constraints, for example, the rate that you can push bits down a fiber-optic cable, or the amount of storage on a physical disk."
  children = [
    benchmark.well_architected_framework_rel01_bp01,
    benchmark.well_architected_framework_rel01_bp02
  ]

  tags = local.well_architected_framework_rel01_common_tags
}


benchmark "well_architected_framework_rel01_bp01" {
  title       = "BP01 Aware of service quotas and constraints"
  description = "Be aware of your default quotas and manage your quota increase requests for your workload architecture. Know which cloud resource constraints, such as disk or network, are potentially impactful."
  // TODO: Review these controls
  children = [
    aws_compliance.control.lambda_function_concurrent_execution_limit_configured,
    aws_compliance.control.lambda_function_dead_letter_queue_configured
  ]

  tags = merge(local.well_architected_framework_rel01_common_tags, {
    choice_id = "rel_manage_service_limits_aware_quotas_and_constraints"
    severity  = "high"
  })
}

benchmark "well_architected_framework_rel01_bp02" {
  title       = "BP02 Manage service quotas across accounts and Regions"
  description = "If you are using multiple accounts or Regions, request the appropriate quotas in all environments in which your production workloads run."
  // TODO: Review these controls
  children = [
    aws_compliance.control.lambda_function_concurrent_execution_limit_configured,
    aws_compliance.control.lambda_function_dead_letter_queue_configured
  ]

  tags = merge(local.well_architected_framework_rel01_common_tags, {
    choice_id = "rel_manage_service_limits_limits_considered"
    severity  = "high"
  })
}