locals {
  well_architected_framework_common_tags = merge(local.aws_well_architected_common_tags, {
    type = "Benchmark"
  })
}

benchmark "well_architected_framework" {
  title         = "AWS Well-Architected Framework"
  description   = "The AWS Well-Architected Framework describes key concepts, design principles, and architectural best practices for designing and running workloads in the cloud. By answering a few foundational questions, learn how well your architecture aligns with cloud best practices and gain guidance for making improvements."
  children = [
    benchmark.well_architected_framework_security
  ]
  tags = local.well_architected_framework_common_tags
}
