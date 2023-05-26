locals {
  well_architected_framework_operational_excellence_common_tags = merge(local.well_architected_framework_common_tags, {
    pillar_id = "operationalExcellence"
  })
}

benchmark "well_architected_framework_operational_excellence" {
  title       = "Operational Excellence"
  description = "Operational excellence is a commitment to build software correctly while consistently delivering a great customer experience. It contains best practices for organizing your team, designing your workload, operating it at scale, and evolving it over time. Operational excellence helps your team to focus more of their time on building new features that benefit customers, and less time on maintenance and firefighting. To build correctly, we look to best practices that result in well-running systems, a balanced workload for you and your team, and most importantly, a great customer experience. The goal of operational excellence is to get new features and bug fixes into customers' hands quickly and reliably. Organizations that invest in operational excellence consistently delight customers while building new features, making changes, and dealing with failures. Along the way, operational excellence drives towards continuous integration and continuous delivery (CI/CD) by helping developers achieve high quality results consistently."
  children = [
    benchmark.well_architected_framework_ops04,
    benchmark.well_architected_framework_ops05
  ]

  tags = local.well_architected_framework_operational_excellence_common_tags
}
