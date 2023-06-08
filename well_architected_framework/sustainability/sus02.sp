locals {
  well_architected_framework_sus02_common_tags = merge(local.well_architected_framework_sustainability_common_tags, {
    question_id = "sus_sus_user"
  })
}

benchmark "well_architected_framework_sus02" {
  title       = "SUS02 How do you align cloud resources to your demand?"
  description = "Scale infrastructure to continually match demand and verify that you use only the minimum resources required to support your users."
  children = [
    benchmark.well_architected_framework_sus02_bp03
  ]

  tags = local.well_architected_framework_sus02_common_tags
}

benchmark "well_architected_framework_sus02_bp03" {
  title       = "BP03 Stop the creation and maintenance of unused assets"
  description = "Decommission unused assets in your workload to reduce the number of cloud resources required to support your demand and minimize waste."
  children = [
    aws_thrifty.control.ecs_cluster_low_utilization,
  ]

  tags = merge(local.well_architected_framework_sus02_common_tags, {
    choice_id = "sus_sus_user_a4"
  })
}
