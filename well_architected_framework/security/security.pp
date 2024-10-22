locals {
  well_architected_framework_security_common_tags = merge(local.well_architected_framework_common_tags, {
    pillar_id = "security"
  })
}

benchmark "well_architected_framework_security" {
  title       = "Security"
  description = "The security pillar focuses on protecting information and systems. Key topics include confidentiality and integrity of data, managing user permissions, and establishing controls to detect security events."
  children = [
    benchmark.well_architected_framework_sec01,
    benchmark.well_architected_framework_sec02,
    benchmark.well_architected_framework_sec03,
    benchmark.well_architected_framework_sec04,
    benchmark.well_architected_framework_sec05,
    benchmark.well_architected_framework_sec06,
    benchmark.well_architected_framework_sec08,
    benchmark.well_architected_framework_sec09,
    benchmark.well_architected_framework_sec10,
    benchmark.well_architected_framework_sec11
  ]

  tags = local.well_architected_framework_security_common_tags
}
