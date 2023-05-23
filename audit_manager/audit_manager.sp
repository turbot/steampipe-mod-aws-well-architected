locals {
  audit_manager_common_tags = merge(local.aws_well_architected_common_tags, {
    type = "Benchmark"
  })
}

benchmark "audit_manager" {
  title         = "AWS Audit Manager"
  description   = "The AWS Well-Architected Framework describes the key concepts, design principles, and architectural best practices for designing and running workloads in the cloud. Of the 5 pillars security and reliability are addressed here."
  children = [
    benchmark.audit_manager_reliability,
    benchmark.audit_manager_security
  ]
  tags = local.audit_manager_common_tags
}
