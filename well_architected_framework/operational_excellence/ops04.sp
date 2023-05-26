locals {
  well_architected_framework_ops04_common_tags = merge(local.well_architected_framework_operational_excellence_common_tags, {
    question_id = "telemetry"
  })
}

benchmark "well_architected_framework_ops04" {
  title       = "OPS04 How do you design your workload so that you can understand its state?"
  description = "Design your workload so that it provides the information necessary across all components(for example, metrics, logs, and traces) for you to understand its internal state. This enables you to provide effective responses when appropriate."
  children = [
    benchmark.well_architected_framework_ops04_bp01,
  ]

  tags = local.well_architected_framework_ops04_common_tags
}

benchmark "well_architected_framework_ops04_bp01" {
  title       = "BP01 Implement application telemetry"
  description = "Application telemetry is the foundation for observability of your workload. Your application should emit telemetry that provides insight into the state of the application and the achievement of business outcomes. From troubleshooting to measuring the impact of a new feature, application telemetry informs the way you build, operate, and evolve your workload."

  children = [
    aws_compliance.control.apigateway_stage_logging_enabled,
    aws_compliance.control.autoscaling_group_with_lb_use_health_check,
    aws_compliance.control.cloudfront_distribution_logging_enabled,
    aws_compliance.control.codebuild_project_logging_enabled,
    aws_compliance.control.ecs_task_definition_logging_enabled,
    aws_compliance.control.elastic_beanstalk_enhanced_health_reporting_enabled,
    aws_compliance.control.elb_application_classic_lb_logging_enabled,
    aws_compliance.control.rds_db_instance_cloudwatch_logs_enabled
  ]

  tags = merge(local.well_architected_framework_ops04_common_tags, {
    choice_id = "ops_telemetry_application_telemetry"
    severity  = "high"
  })
}

benchmark "well_architected_framework_ops04_bp02" {
  title       = "BP02 Implement and configure workload telemetry"
  description = "Design and configure your workload to emit information about its internal state and current status, for example, API call volume, HTTP status codes, and scaling events. Use this information to help determine when a response is required."

  children = [
    aws_compliance.control.cloudtrail_trail_enabled,
    aws_compliance.control.cloudtrail_trail_integrated_with_logs,
    aws_compliance.control.cloudwatch_alarm_action_enabled,
    aws_compliance.control.ec2_instance_detailed_monitoring_enabled,
    aws_compliance.control.vpc_flow_logs_enabled
  ]

  tags = merge(local.well_architected_framework_ops04_common_tags, {
    choice_id = "ops_telemetry_workload_telemetry"
    severity  = "high"
  })
}
