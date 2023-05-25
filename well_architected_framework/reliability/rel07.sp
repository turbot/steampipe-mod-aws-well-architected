locals {
  well_architected_framework_rel06_common_tags = merge(local.well_architected_framework_reliability_common_tags, {
    question_id = "adapt-to-changes"
  })
}

benchmark "well_architected_framework_rel07" {
  title       = "REL07 How do you design your workload to adapt to changes in demand?"
  description = "A scalable workload provides elasticity to add or remove resources automatically so that they closely match the current demand at any given point in time."
  children = [
    benchmark.well_architected_framework_reliability_rel07_bp01,
    # benchmark.well_architected_framework_reliability_rel07_bp03
  ]

  tags = local.well_architected_framework_rel06_common_tags
}

benchmark "well_architected_framework_reliability_rel07_bp01" {
  title       = "BP01 Use automation when obtaining or scaling resources"
  description = "When replacing impaired resources or scaling your workload, automate the process by using managed AWS services, such as Amazon S3 and AWS Auto Scaling. You can also use third-party tools and AWS SDKs to automate scaling. Managed AWS services include Amazon S3, Amazon CloudFront, AWS Auto Scaling, AWS Lambda, Amazon DynamoDB, AWS Fargate, and Amazon Route 53. AWS Auto Scaling lets you detect and replace impaired instances. It also lets you build scaling plans for resources including Amazon EC2 instances and Spot Fleets, Amazon ECS tasks, Amazon DynamoDB tables and indexes, and Amazon Aurora Replicas."
  // TODO: Review these controls
  children = [
    aws_compliance.control.autoscaling_group_multiple_az_configured,
    aws_compliance.control.dynamodb_table_auto_scaling_enabled
  ]

  tags = merge(local.well_architected_framework_rel06_common_tags, {
    // TO DO
    choice_id = "rel_planning_network_topology_ha_conn_users"
    severity  = "high"
  })
}

# benchmark "well_architected_framework_reliability_rel07_bp03" {
#   title       = "BP03 Obtain resources upon detection that more resources are needed for a workload"
#   description = "Scale resources proactively to meet demand and avoid availability impact. Many AWS services automatically scale to meet demand. If using Amazon EC2 instances or Amazon ECS clusters, you can configure automatic scaling of these to occur based on usage metrics that correspond to demand for your workload. For Amazon EC2, average CPU utilization, load balancer request count, or network bandwidth can be used to scale out (or scale in) EC2 instances. For Amazon ECS, average CPU utilization, load balancer request count, and memory utilization can be used to scale out (or scale in) ECS tasks. Using Target Auto Scaling on AWS, the autoscaler acts like a household thermostat, adding or removing resources to maintain the target value (for example, 70% CPU utilization) that you specify."
#   // TODO: Review these controls
#   children = [
#     aws_compliance.control.es_domain_data_nodes_min_3,
#     aws_compliance.control.es_domain_dedicated_master_nodes_min_3,
#   ]

#   tags = merge(local.well_architected_framework_rel06_common_tags, {
#     // TO DO
#     choice_id = "rel_planning_network_topology_ha_conn_users"
#     severity  = "high"
#   })
# }
