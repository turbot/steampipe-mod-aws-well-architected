locals {
  well_architected_framework_rel07_common_tags = merge(local.well_architected_framework_reliability_common_tags, {
    question_id = "adapt-to-changes"
  })
}

benchmark "well_architected_framework_rel07" {
  title       = "REL07 How do you design your workload to adapt to changes in demand?"
  description = "A scalable workload provides elasticity to add or remove resources automatically so that they closely match the current demand at any given point in time."
  children = [
    benchmark.well_architected_framework_rel07_bp01,
    # benchmark.well_architected_framework_rel07_bp03
  ]

  tags = local.well_architected_framework_rel07_common_tags
}

benchmark "well_architected_framework_rel07_bp01" {
  title       = "BP01 Use automation when obtaining or scaling resources"
  description = "When replacing impaired resources or scaling your workload, automate the process by using managed AWS services, such as Amazon S3 and AWS Auto Scaling. You can also use third-party tools and AWS SDKs to automate scaling. Managed AWS services include Amazon S3, Amazon CloudFront, AWS Auto Scaling, AWS Lambda, Amazon DynamoDB, AWS Fargate, and Amazon Route 53. AWS Auto Scaling lets you detect and replace impaired instances. It also lets you build scaling plans for resources including Amazon EC2 instances and Spot Fleets, Amazon ECS tasks, Amazon DynamoDB tables and indexes, and Amazon Aurora Replicas."
  children = [
    aws_compliance.control.autoscaling_group_multiple_az_configured,
    aws_compliance.control.dynamodb_table_auto_scaling_enabled
  ]

  tags = merge(local.well_architected_framework_rel07_common_tags, {
    choice_id = "rel_adapt_to_changes_autoscale_adapt"
    risk      = "high"
  })
}
