locals {
  well_architected_framework_rel08_common_tags = merge(local.well_architected_framework_reliability_common_tags, {
    question_id = "tracking-change-management"
  })
}

benchmark "well_architected_framework_rel08" {
  title       = "REL08 How do you implement change?"
  description = "Controlled changes are necessary to deploy new functionality, and to ensure that the workloads and the operating environment are running known software and can be patched or replaced in a predictable manner. If these changes are uncontrolled, then it makes it difficult to predict the effect of these changes, or to address issues that arise because of them."
  children = [
    benchmark.well_architected_framework_rel08_bp05
  ]

  tags = local.well_architected_framework_rel08_common_tags
}

benchmark "well_architected_framework_rel08_bp05" {
  title       = "BP05 Deploy changes with automation"
  description = "Deployments and patching are automated to eliminate negative impact. Making changes to production systems is one of the largest risk areas for many organizations. We consider deployments a first-class problem to be solved alongside the business problems that the software addresses. Today, this means the use of automation wherever practical in operations, including testing and deploying changes, adding or removing capacity, and migrating data. AWS CodePipeline lets you manage the steps required to release your workload. This includes a deployment state using AWS CodeDeploy to automate deployment of application code to Amazon EC2 instances, on-premises instances, serverless Lambda functions, or Amazon ECS services."
  // TODO: Review these controls
  children = [
    aws_compliance.control.rds_db_instance_automatic_minor_version_upgrade_enabled
  ]

  tags = merge(local.well_architected_framework_rel08_common_tags, {
    choice_id = "rel_tracking_change_management_automated_changemgmt"
    severity  = "high"
  })
}
