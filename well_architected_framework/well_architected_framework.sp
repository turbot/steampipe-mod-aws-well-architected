locals {
  well_architected_framework_common_tags = merge(local.aws_well_architected_common_tags, {
    type = "Benchmark"
  })
}

benchmark "well_architected_framework" {
  title       = "AWS Well-Architected Framework"
  description = "The AWS Well-Architected Framework describes key concepts, design principles, and architectural best practices for designing and running workloads in the cloud. By answering a few foundational questions, learn how well your architecture aligns with cloud best practices and gain guidance for making improvements."
  documentation = file("./well_architected_framework/docs/well_architected_framework_overview.md")

  children = [
    benchmark.well_architected_framework_operational_excellence,
    benchmark.well_architected_framework_reliability,
    benchmark.well_architected_framework_security,
    benchmark.well_architected_framework_sustainability
  ]

  tags = local.well_architected_framework_common_tags
}
