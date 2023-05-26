locals {
  well_architected_framework_reliability_common_tags = merge(local.well_architected_framework_common_tags, {
    pillar_id = "reliability"
  })
}

benchmark "well_architected_framework_reliability" {
  title       = "Reliability"
  description = "The reliability pillar focuses on workloads performing their intended functions and how to recover quickly from failure to meet demands. Key topics include distributed system design, recovery planning, and adapting to changing requirements."
  children = [
    benchmark.well_architected_framework_rel01,
    benchmark.well_architected_framework_rel02,
    benchmark.well_architected_framework_rel06,
    benchmark.well_architected_framework_rel07,
    benchmark.well_architected_framework_rel08,
    benchmark.well_architected_framework_rel09,
  ]

  tags = local.well_architected_framework_reliability_common_tags
}
