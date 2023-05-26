locals {
  well_architected_framework_rel06_common_tags = merge(local.well_architected_framework_reliability_common_tags, {
    question_id = "monitor-aws-resources"
  })
}

benchmark "well_architected_framework_rel06" {
  title       = "REL06 How do you monitor workload resources?"
  description = "Logs and metrics are powerful tools to gain insight into the health of your workload. You can configure your workload to monitor logs and metrics and send notifications when thresholds are crossed or significant events occur. Monitoring enables your workload to recognize when low-performance thresholds are crossed or failures occur, so it can recover automatically in response."
  children = [
    benchmark.well_architected_framework_rel06_bp01,
    benchmark.well_architected_framework_rel06_bp02
  ]

  tags = local.well_architected_framework_rel06_common_tags
}

benchmark "well_architected_framework_rel06_bp01" {
  title       = "BP01 Monitor all components for the workload"
  description = "Monitor the components of the workload with Amazon CloudWatch or third-party tools. Monitor AWS services with AWS Health Dashboard. All components of your workload should be monitored, including the front-end, business logic, and storage tiers. Define key metrics, describe how to extract them from logs (if necessary), and set thresholds for invoking corresponding alarm events. Ensure metrics are relevant to the key performance indicators (KPIs) of your workload, and use metrics and logs to identify early warning signs of service degradation. For example, a metric related to business outcomes such as the number of orders successfully processed per minute, can indicate workload issues faster than technical metric, such as CPU Utilization. Use AWS Health Dashboard for a personalized view into the performance and availability of the AWS services underlying your AWS resources."
  // TODO: Review these controls
  children = [
    aws_compliance.control.ec2_instance_detailed_monitoring_enabled,
    aws_compliance.control.apigateway_stage_logging_enabled,
    aws_compliance.control.acm_certificate_transparency_logging_enabled,
    aws_compliance.control.codebuild_project_logging_enabled,
    aws_compliance.control.ecs_task_definition_logging_enabled,
    aws_compliance.control.elb_application_classic_lb_logging_enabled,
    aws_compliance.control.lambda_function_cloudtrail_logging_enabled,
    aws_compliance.control.opensearch_domain_audit_logging_enabled,
    aws_compliance.control.rds_db_instance_logging_enabled,
    aws_compliance.control.route53_zone_query_logging_enabled,
    aws_compliance.control.s3_bucket_logging_enabled,
    aws_compliance.control.s3_bucket_object_logging_enabled,
    aws_compliance.control.waf_web_acl_logging_enabled
  ]

  tags = merge(local.well_architected_framework_rel06_common_tags, {
    choice_id = "rel_monitor_aws_resources_monitor_resources"
    severity  = "high"
  })
}

benchmark "well_architected_framework_rel06_bp02" {
  title       = "BP02 Define and calculate metrics (Aggregation)"
  description = "Store log data and apply filters where necessary to calculate metrics, such as counts of a specific log event, or latency calculated from log event timestamps.Amazon CloudWatch and Amazon S3 serve as the primary aggregation and storage layers. For some services, such as AWS Auto Scaling and Elastic Load Balancing, default metrics are provided by default for CPU load or average request latency across a cluster or instance. For streaming services, such as VPC Flow Logs and AWS CloudTrail, event data is forwarded to CloudWatch Logs and you need to define and apply metrics filters to extract metrics from the event data. This gives you time series data, which can serve as inputs to CloudWatch alarms that you define to invoke alerts."
  // TODO: Review these controls
  children = [
    aws_compliance.control.ecs_cluster_container_insights_enabled,
    aws_compliance.control.elastic_beanstalk_enhanced_health_reporting_enabled
  ]

  tags = merge(local.well_architected_framework_rel06_common_tags, {
    choice_id = "rel_planning_network_topology_ha_conn_users"
    severity  = "high"
  })
}
