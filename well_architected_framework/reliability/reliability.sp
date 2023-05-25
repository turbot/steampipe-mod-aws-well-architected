locals {
  well_architected_framework_reliability_common_tags = merge(local.well_architected_framework_common_tags, {
    pillar = "reliability"
  })
}

benchmark "well_architected_framework_reliability" {
  title       = "Reliability Pillar"
  description = "The reliability pillar focuses on workloads performing their intended functions and how to recover quickly from failure to meet demands. Key topics include distributed system design, recovery planning, and adapting to changing requirements."
  children = [
    benchmark.well_architected_framework_rel01,
    benchmark.well_architected_framework_rel02,
    benchmark.well_architected_framework_rel06
  ]

  tags = local.well_architected_framework_reliability_common_tags
}