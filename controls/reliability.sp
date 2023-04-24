locals {
  reliability_common_tags = merge(local.aws_well_architected_common_tags, {
    benchmark = "reliability"
  })
}

benchmark "reliability" {
  title       = "Reliability Pillar"
  description = "The reliability pillar focuses on workloads performing their intended functions and how to recover quickly from failure to meet demands. Key topics include distributed system design, recovery planning, and adapting to changing requirements."
  children = [
    benchmark.reliability_1,
    benchmark.reliability_2,
    benchmark.reliability_6,
    benchmark.reliability_7,
    benchmark.reliability_8,
    benchmark.reliability_9,
    benchmark.reliability_10
  ]

  tags = merge(local.reliability_common_tags, {
    type = "Benchmark"
  })
}

benchmark "reliability_1" {
  title       = "REL 1: How do you manage service quotas and constraints?"
  description = "For cloud-based workload architectures, there are service quotas (which are also referred to as service limits). These quotas exist to prevent accidentally provisioning more resources than you need and to limit request rates on API operations so as to protect services from abuse. There are also resource constraints, for example, the rate that you can push bits down a fiber-optic cable, or the amount of storage on a physical disk."
  children = [
    aws_compliance.control.lambda_function_concurrent_execution_limit_configured,
    aws_compliance.control.lambda_function_dead_letter_queue_configured
  ]

  tags = merge(local.reliability_common_tags, {
    type = "Benchmark"
  })
}

benchmark "reliability_2" {
  title       = "REL 2: How do you plan your network topology?"
  description = "Workloads often exist in multiple environments. These include multiple cloud environments (both publicly accessible and private) and possibly your existing data center infrastructure. Plans must include network considerations such as intra- and inter-system connectivity, public IP address management, private IP address management, and domain name resolution."
  children = [
    aws_compliance.control.ec2_instance_in_vpc,
    aws_compliance.control.elb_application_lb_waf_enabled,
    aws_compliance.control.elb_classic_lb_cross_zone_load_balancing_enabled,
    aws_compliance.control.es_domain_in_vpc,
    aws_compliance.control.lambda_function_in_vpc,
    aws_compliance.control.redshift_cluster_enhanced_vpc_routing_enabled,
    aws_compliance.control.vpc_endpoint_service_acceptance_required_enabled,
    aws_compliance.control.vpc_security_group_restrict_ingress_tcp_udp_all,
    aws_compliance.control.vpc_vpn_tunnel_up,
    control.elb_network_lb_cross_zone_load_balancing_enabled,
    control.vpc_peering_dns_resolution_check
  ]

  tags = merge(local.reliability_common_tags, {
    type = "Benchmark"
  })
}

benchmark "reliability_6" {
  title       = "REL 6: How do you monitor workload resources?"
  description = "Logs and metrics are powerful tools to gain insight into the health of your workload. You can configure your workload to monitor logs and metrics and send notifications when thresholds are crossed or significant events occur. Monitoring enables your workload to recognize when low-performance thresholds are crossed or failures occur, so it can recover automatically in response."
  children = [
    aws_compliance.control.apigateway_rest_api_stage_xray_tracing_enabled,
    aws_compliance.control.apigateway_stage_logging_enabled,
    aws_compliance.control.autoscaling_group_with_lb_use_health_check,
    aws_compliance.control.cloudtrail_multi_region_trail_enabled,
    aws_compliance.control.cloudtrail_trail_enabled,
    aws_compliance.control.cloudtrail_trail_integrated_with_logs,
    aws_compliance.control.cloudwatch_alarm_action_enabled,
    aws_compliance.control.ec2_instance_detailed_monitoring_enabled,
    aws_compliance.control.ecs_cluster_container_insights_enabled,
    aws_compliance.control.elastic_beanstalk_enhanced_health_reporting_enabled,
    aws_compliance.control.elb_application_classic_lb_logging_enabled,
    aws_compliance.control.es_domain_logs_to_cloudwatch,
    aws_compliance.control.guardduty_enabled,
    aws_compliance.control.lambda_function_dead_letter_queue_configured,
    aws_compliance.control.opensearch_domain_logs_to_cloudwatch,
    aws_compliance.control.rds_db_instance_and_cluster_enhanced_monitoring_enabled,
    aws_compliance.control.rds_db_instance_logging_enabled,
    aws_compliance.control.redshift_cluster_enhanced_vpc_routing_enabled,
    aws_compliance.control.s3_bucket_logging_enabled,
    aws_compliance.control.securityhub_enabled,
    aws_compliance.control.vpc_flow_logs_enabled,
    aws_compliance.control.wafv2_web_acl_logging_enabled
  ]

  tags = merge(local.reliability_common_tags, {
    type = "Benchmark"
  })
}

benchmark "reliability_7" {
  title       = "REL 7: How do you design your workload to adapt to changes in demand?"
  description = "A scalable workload provides elasticity to add or remove resources automatically so that they closely match the current demand at any given point in time."
  children = [
    aws_compliance.control.autoscaling_group_with_lb_use_health_check,
    aws_compliance.control.autoscaling_launch_config_public_ip_disabled,
    aws_compliance.control.dynamodb_table_auto_scaling_enabled
  ]

  tags = merge(local.reliability_common_tags, {
    type = "Benchmark"
  })
}

benchmark "reliability_8" {
  title       = "REL 8: How do you implement change?"
  description = "Controlled changes are necessary to deploy new functionality, and to ensure that the workloads and the operating environment are running known software and can be patched or replaced in a predictable manner. If these changes are uncontrolled, then it makes it difficult to predict the effect of these changes, or to address issues that arise because of them."
  children = [
    aws_compliance.control.rds_db_instance_automatic_minor_version_upgrade_enabled,
    aws_compliance.control.redshift_cluster_maintenance_settings_check,
    aws_compliance.control.ssm_managed_instance_compliance_patch_compliant
  ]

  tags = merge(local.reliability_common_tags, {
    type = "Benchmark"
  })
}

benchmark "reliability_9" {
  title       = "REL 9: How do you back up data?"
  description = "Back up data, applications, and configuration to meet your requirements for recovery time objectives (RTO) and recovery point objectives (RPO)."
  children = [
    aws_compliance.control.backup_plan_min_retention_35_days,
    aws_compliance.control.backup_recovery_point_encryption_enabled,
    aws_compliance.control.backup_recovery_point_min_retention_35_days,
    aws_compliance.control.dynamodb_table_encrypted_with_kms,
    aws_compliance.control.dynamodb_table_in_backup_plan,
    aws_compliance.control.dynamodb_table_point_in_time_recovery_enabled,
    aws_compliance.control.ebs_attached_volume_encryption_enabled,
    aws_compliance.control.ebs_volume_in_backup_plan,
    aws_compliance.control.ec2_ebs_default_encryption_enabled,
    aws_compliance.control.ec2_instance_ebs_optimized,
    aws_compliance.control.ec2_instance_protected_by_backup_plan,
    aws_compliance.control.efs_file_system_encrypted_with_cmk,
    aws_compliance.control.efs_file_system_in_backup_plan,
    aws_compliance.control.elasticache_redis_cluster_automatic_backup_retention_15_days,
    aws_compliance.control.elb_application_lb_deletion_protection_enabled,
    aws_compliance.control.fsx_file_system_protected_by_backup_plan,
    aws_compliance.control.rds_db_cluster_aurora_protected_by_backup_plan,
    aws_compliance.control.rds_db_instance_backup_enabled,
    aws_compliance.control.rds_db_instance_deletion_protection_enabled,
    aws_compliance.control.rds_db_instance_encryption_at_rest_enabled,
    aws_compliance.control.rds_db_instance_in_backup_plan,
    aws_compliance.control.rds_db_snapshot_encrypted_at_rest,
    aws_compliance.control.redshift_cluster_automatic_snapshots_min_7_days,
    aws_compliance.control.redshift_cluster_kms_enabled,
    aws_compliance.control.s3_bucket_cross_region_replication_enabled,
    aws_compliance.control.s3_bucket_default_encryption_enabled_kms,
    aws_compliance.control.s3_bucket_default_encryption_enabled,
    aws_compliance.control.s3_bucket_object_lock_enabled,
    aws_compliance.control.s3_bucket_versioning_enabled
  ]

  tags = merge(local.reliability_common_tags, {
    type = "Benchmark"
  })
}

benchmark "reliability_10" {
  title       = "REL 10: How do you use fault isolation to protect your workload?"
  description = "Fault isolated boundaries limit the effect of a failure within a workload to a limited number of components. Components outside of the boundary are unaffected by the failure. Using multiple fault isolated boundaries, you can limit the impact on your workload."
  children = [
    aws_compliance.control.dynamodb_table_auto_scaling_enabled,
    aws_compliance.control.elb_application_gateway_network_lb_multiple_az_configured,
    aws_compliance.control.elb_application_lb_deletion_protection_enabled,
    aws_compliance.control.elb_classic_lb_cross_zone_load_balancing_enabled,
    aws_compliance.control.elb_classic_lb_multiple_az_configured,
    aws_compliance.control.lambda_function_multiple_az_configured,
    aws_compliance.control.rds_db_instance_deletion_protection_enabled,
    aws_compliance.control.rds_db_instance_multiple_az_enabled,
    aws_compliance.control.s3_bucket_object_lock_enabled,
    aws_compliance.control.vpc_vpn_tunnel_up,
    control.opensearch_domain_data_node_fault_tolerance
  ]

  tags = merge(local.reliability_common_tags, {
    type = "Benchmark"
  })
}
