locals {
  well_architected_framework_sustainability_common_tags = merge(local.well_architected_framework_common_tags, {
    pillar_id = "sustainability"
  })
}

benchmark "well_architected_framework_sustainability" {
  title       = "Sustainability"
  description = "The Sustainability pillar addresses the long-term environmental, economic, and societal impact of your business activities."
  children = [
    benchmark.well_architected_framework_sus02
  ]

  tags = local.well_architected_framework_sustainability_common_tags
}
