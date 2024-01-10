locals {
  well_architected_framework_sec04_common_tags = merge(local.well_architected_framework_security_common_tags, {
    question_id = "detect-investigate-events"
  })
}

benchmark "well_architected_framework_sec04" {
  title       = "SEC04 How do you detect and investigate security events?"
  description = "Capture and analyze events from logs and metrics to gain visibility. Take action on security events and potential threats to help secure your workload."
  children = [
    benchmark.well_architected_framework_sec04_bp01,
    benchmark.well_architected_framework_sec04_bp02,
    benchmark.well_architected_framework_sec04_bp03
  ]

  tags = local.well_architected_framework_sec04_common_tags
}

benchmark "well_architected_framework_sec04_bp01" {
  title       = "BP01 Configure service and application logging"
  description = "Retain security event logs from services and applications. This is a fundamental principle of security for audit, investigations, and operational use cases, and a common security requirement driven by governance, risk, and compliance (GRC) standards, policies, and procedures.An organization should be able to reliably and consistently retrieve security event logs from AWS services and applications in a timely manner when required to fulfill an internal process or obligation, such as a security incident response. Consider centralizing logs for better operational results."
  children = [
    aws_compliance.control.apigateway_stage_logging_enabled,
    aws_compliance.control.opensearch_domain_audit_logging_enabled,
    aws_compliance.control.cloudtrail_trail_integrated_with_logs,
    aws_compliance.control.cloudtrail_s3_data_events_enabled,
    aws_compliance.control.acm_certificate_transparency_logging_enabled,
    aws_compliance.control.lambda_function_cloudtrail_logging_enabled,
    aws_compliance.control.cloudfront_distribution_logging_enabled,
    aws_compliance.control.cis_v150_3_10,
    aws_compliance.control.cis_v130_3_11,
    aws_compliance.control.eks_cluster_control_plane_audit_logging_enabled,
    aws_compliance.control.elb_application_classic_lb_logging_enabled,
    aws_compliance.control.rds_db_instance_cloudwatch_logs_enabled,
    aws_compliance.control.redshift_cluster_audit_logging_enabled,
    aws_compliance.control.route53_zone_query_logging_enabled,
    aws_compliance.control.s3_bucket_object_logging_enabled,
    aws_compliance.control.vpc_flow_logs_enabled
  ]

  tags = merge(local.well_architected_framework_sec04_common_tags, {
    choice_id = "sec_detect_investigate_events_app_service_logging"
    risk      = "high"
  })
}

benchmark "well_architected_framework_sec04_bp02" {
  title       = "BP02 Analyze logs, findings, and metrics centrally"
  description = "Security operations teams rely on the collection of logs and the use of search tools to discover potential events of interest, which might indicate unauthorized activity or unintentional change. However, simply analyzing collected data and manually processing information is insufficient to keep up with the volume of information flowing from complex architectures. Analysis and reporting alone don’t facilitate the assignment of the right resources to work an event in a timely fashion."
  children = [
    aws_compliance.control.es_domain_logs_to_cloudwatch,
    aws_compliance.control.cloudtrail_multi_region_trail_enabled,
    aws_compliance.control.rds_db_instance_logging_enabled,
    aws_compliance.control.vpc_flow_logs_enabled,
    aws_compliance.control.wafv2_web_acl_logging_enabled,
    aws_compliance.control.cloudtrail_security_trail_enabled,
    aws_compliance.control.redshift_cluster_audit_logging_enabled,
    aws_compliance.control.config_enabled_all_regions
  ]

  tags = merge(local.well_architected_framework_sec04_common_tags, {
    choice_id = "sec_detect_investigate_events_analyze_all"
    risk      = "high"
  })
}

benchmark "well_architected_framework_sec04_bp03" {
  title       = "BP03 Automate response to events"
  description = "Using automation to investigate and remediate events reduces human effort and error, and allows you to scale investigation capabilities. Regular reviews will help you tune automation tools, and continuously iterate. In AWS, investigating events of interest and information on potentially unexpected changes into an automated workflow can be achieved using Amazon EventBridge. This service provides a scalable rules engine designed to broker both native AWS event formats (such as AWS CloudTrail events), as well as custom events you can generate from your application. Amazon GuardDuty also allows you to route events to a workflow system for those building incident response systems (AWS Step Functions), or to a central Security Account, or to a bucket for further analysis."
  children = [
    aws_compliance.control.es_domain_logs_to_cloudwatch,
    aws_compliance.control.elb_application_classic_lb_logging_enabled,
    aws_compliance.control.cloudtrail_multi_region_trail_enabled,
    aws_compliance.control.rds_db_instance_logging_enabled,
    aws_compliance.control.vpc_flow_logs_enabled,
    aws_compliance.control.wafv2_web_acl_logging_enabled,
    aws_compliance.control.cloudtrail_security_trail_enabled,
    aws_compliance.control.redshift_cluster_audit_logging_enabled,
  ]

  tags = merge(local.well_architected_framework_sec04_common_tags, {
    choice_id = "sec_detect_investigate_events_auto_response"
    risk      = "medium"
  })
}
