locals {
  security_common_tags = merge(local.aws_well_architected_common_tags, {
    benchmark = "security"
  })
}

benchmark "security" {
  title       = "Security Pillar"
  description = "The security pillar focuses on protecting information and systems. Key topics include confidentiality and integrity of data, managing user permissions, and establishing controls to detect security events."
  children = [
    benchmark.security_1,
    benchmark.security_2,
    benchmark.security_3,
    benchmark.security_4,
    benchmark.security_5,
    benchmark.security_6,
    benchmark.security_7,
    benchmark.security_8,
    benchmark.security_9
  ]

  tags = merge(local.security_common_tags, {
    type = "Benchmark"
  })
}

benchmark "security_1" {
  title       = "SEC 1: How do you securely operate your workload?"
  description = "To operate your workload securely, you must apply overarching best practices to every area of security. Take requirements and processes that you have defined in operational excellence at an organizational and workload level, and apply them to all areas. Staying up to date with AWS and industry recommendations and threat intelligence helps you evolve your threat model and control objectives. Automating security processes, testing, and validation allow you to scale your security operations."
  children = [
    aws_compliance.control.account_part_of_organizations,
    aws_compliance.control.codebuild_project_plaintext_env_variables_no_sensitive_aws_values,
    aws_compliance.control.ec2_instance_ssm_managed,
    aws_compliance.control.iam_root_user_hardware_mfa_enabled,
    aws_compliance.control.iam_root_user_mfa_enabled,
    aws_compliance.control.iam_root_user_no_access_keys,
    aws_compliance.control.iam_user_console_access_mfa_enabled,
    aws_compliance.control.iam_user_mfa_enabled,
    aws_compliance.control.ssm_managed_instance_compliance_association_compliant,
    aws_compliance.control.ssm_managed_instance_compliance_patch_compliant
  ]

  tags = merge(local.security_common_tags, {
    type = "Benchmark"
  })
}

benchmark "security_2" {
  title       = "SEC 2: How do you manage identities for people and machines?"
  description = "There are two types of identities you need to manage when approaching operating secure AWS workloads. Understanding the type of identity you need to manage and grant access helps you ensure the right identities have access to the right resources under the right conditions. Human Identities: Your administrators, developers, operators, and end users require an identity to access your AWS environments and applications. These are members of your organization, or external users with whom you collaborate, and who interact with your AWS resources via a web browser, client application, or interactive command-line tools. Machine Identities: Your service applications, operational tools, and workloads require an identity to make requests to AWS services - for example, to read data. These identities include machines running in your AWS environment such as Amazon EC2 instances or AWS Lambda functions. You may also manage machine identities for external parties who need access. Additionally, you may also have machines outside of AWS that need access to your AWS environment."
  children = [
    aws_compliance.control.ecs_task_definition_user_for_host_mode_check,
    aws_compliance.control.iam_account_password_policy_strong,
    aws_compliance.control.iam_all_policy_no_service_wild_card,
    aws_compliance.control.iam_group_not_empty,
    aws_compliance.control.iam_group_user_role_no_inline_policies,
    aws_compliance.control.iam_policy_custom_no_assume_role,
    aws_compliance.control.iam_policy_custom_no_blocked_kms_actions,
    aws_compliance.control.iam_policy_no_star_star,
    aws_compliance.control.iam_root_user_hardware_mfa_enabled,
    aws_compliance.control.iam_root_user_mfa_enabled,
    aws_compliance.control.iam_user_access_key_age_90,
    aws_compliance.control.iam_user_console_access_mfa_enabled,
    aws_compliance.control.iam_user_in_group,
    aws_compliance.control.iam_user_mfa_enabled,
    aws_compliance.control.iam_user_unused_credentials_90,
    aws_compliance.control.secretsmanager_secret_automatic_rotation_enabled,
    aws_compliance.control.secretsmanager_secret_encrypted_with_kms_cmk,
    aws_compliance.control.secretsmanager_secret_last_changed_90_day,
    aws_compliance.control.secretsmanager_secret_rotated_as_scheduled,
    aws_compliance.control.secretsmanager_secret_unused_90_day
  ]

  tags = merge(local.security_common_tags, {
    type = "Benchmark"
  })
}

benchmark "security_3" {
  title       = "SEC 3: How do you manage permissions for people and machines?"
  description = "Each component or resource of your workload needs to be accessed by administrators, end users, or other components. Have a clear definition of who or what should have access to each component, choose the appropriate identity type and method of authentication and authorization."
  children = [
    aws_compliance.control.account_part_of_organizations,
    aws_compliance.control.autoscaling_launch_config_public_ip_disabled,
    aws_compliance.control.dms_replication_instance_not_publicly_accessible,
    aws_compliance.control.ebs_snapshot_not_publicly_restorable,
    aws_compliance.control.ec2_instance_iam_profile_attached,
    aws_compliance.control.ec2_instance_in_vpc,
    aws_compliance.control.ec2_instance_not_publicly_accessible,
    aws_compliance.control.ec2_instance_uses_imdsv2,
    aws_compliance.control.ecs_task_definition_user_for_host_mode_check,
    aws_compliance.control.emr_cluster_kerberos_enabled,
    aws_compliance.control.emr_cluster_master_nodes_no_public_ip,
    aws_compliance.control.es_domain_in_vpc,
    aws_compliance.control.iam_all_policy_no_service_wild_card,
    aws_compliance.control.iam_group_not_empty,
    aws_compliance.control.iam_group_user_role_no_inline_policies,
    aws_compliance.control.iam_policy_custom_no_blocked_kms_actions,
    aws_compliance.control.iam_policy_no_star_star,
    aws_compliance.control.iam_root_user_no_access_keys,
    aws_compliance.control.iam_user_in_group,
    aws_compliance.control.iam_user_unused_credentials_90,
    aws_compliance.control.lambda_function_in_vpc,
    aws_compliance.control.lambda_function_restrict_public_access,
    aws_compliance.control.opensearch_domain_in_vpc,
    aws_compliance.control.rds_db_instance_prohibit_public_access,
    aws_compliance.control.rds_db_snapshot_prohibit_public_access,
    aws_compliance.control.redshift_cluster_prohibit_public_access,
    aws_compliance.control.s3_bucket_restrict_public_read_access,
    aws_compliance.control.s3_bucket_restrict_public_write_access,
    aws_compliance.control.s3_public_access_block_bucket_account,
    aws_compliance.control.s3_public_access_block_bucket,
    aws_compliance.control.sagemaker_notebook_instance_direct_internet_access_disabled,
    aws_compliance.control.secretsmanager_secret_unused_90_day,
    aws_compliance.control.vpc_subnet_auto_assign_public_ip_disabled,
    control.ecs_task_definition_container_non_privileged,
    control.ecs_task_definition_container_readonly_root_filesystem,
    control.ecs_task_definition_non_root_user,
    control.efs_access_point_enforces_user_identity
  ]

  tags = merge(local.security_common_tags, {
    type = "Benchmark"
  })
}

benchmark "security_4" {
  title       = "SEC 4: How do you detect and investigate security events?"
  description = "Capture and analyze events from logs and metrics to gain visibility. Take action on security events and potential threats to help secure your workload."
  children = [
    aws_compliance.control.apigateway_stage_logging_enabled,
    aws_compliance.control.cloudtrail_multi_region_trail_enabled,
    aws_compliance.control.cloudtrail_s3_data_events_enabled,
    aws_compliance.control.cloudtrail_security_trail_enabled,
    aws_compliance.control.cloudtrail_trail_integrated_with_logs,
    aws_compliance.control.cloudwatch_alarm_action_enabled,
    aws_compliance.control.cloudwatch_log_group_retention_period_365,
    aws_compliance.control.elb_application_classic_lb_logging_enabled,
    aws_compliance.control.es_domain_logs_to_cloudwatch,
    aws_compliance.control.guardduty_enabled,
    aws_compliance.control.opensearch_domain_audit_logging_enabled,
    aws_compliance.control.opensearch_domain_logs_to_cloudwatch,
    aws_compliance.control.rds_db_instance_logging_enabled,
    aws_compliance.control.redshift_cluster_encryption_logging_enabled,
    aws_compliance.control.s3_bucket_logging_enabled,
    aws_compliance.control.securityhub_enabled,
    aws_compliance.control.vpc_flow_logs_enabled,
    aws_compliance.control.wafv2_web_acl_logging_enabled
  ]

  tags = merge(local.security_common_tags, {
    type = "Benchmark"
  })
}

benchmark "security_5" {
  title       = "SEC 5: How do you protect your network resources?"
  description = "Any workload that has some form of network connectivity, whether it’s the internet or a private network, requires multiple layers of defense to help protect from external and internal network-based threats."
  children = [
    aws_compliance.control.apigateway_stage_use_waf_web_acl,
    aws_compliance.control.autoscaling_launch_config_public_ip_disabled,
    aws_compliance.control.dms_replication_instance_not_publicly_accessible,
    aws_compliance.control.ebs_snapshot_not_publicly_restorable,
    aws_compliance.control.ec2_instance_in_vpc,
    aws_compliance.control.ec2_instance_not_publicly_accessible,
    aws_compliance.control.elb_application_lb_waf_enabled,
    aws_compliance.control.emr_cluster_master_nodes_no_public_ip,
    aws_compliance.control.es_domain_in_vpc,
    aws_compliance.control.guardduty_enabled,
    aws_compliance.control.lambda_function_in_vpc,
    aws_compliance.control.lambda_function_restrict_public_access,
    aws_compliance.control.opensearch_domain_in_vpc,
    aws_compliance.control.rds_db_instance_prohibit_public_access,
    aws_compliance.control.rds_db_snapshot_prohibit_public_access,
    aws_compliance.control.redshift_cluster_enhanced_vpc_routing_enabled,
    aws_compliance.control.redshift_cluster_prohibit_public_access,
    aws_compliance.control.s3_bucket_restrict_public_read_access,
    aws_compliance.control.s3_bucket_restrict_public_write_access,
    aws_compliance.control.s3_public_access_block_account,
    aws_compliance.control.s3_public_access_block_bucket,
    aws_compliance.control.sagemaker_notebook_instance_direct_internet_access_disabled,
    aws_compliance.control.vpc_default_security_group_restricts_all_traffic,
    aws_compliance.control.vpc_flow_logs_enabled,
    aws_compliance.control.vpc_igw_attached_to_authorized_vpc,
    aws_compliance.control.vpc_network_acl_remote_administration,
    aws_compliance.control.vpc_network_acl_unused,
    aws_compliance.control.vpc_route_table_restrict_public_access_to_igw,
    aws_compliance.control.vpc_security_group_restrict_ingress_ssh_all,
    aws_compliance.control.vpc_security_group_restrict_ingress_tcp_udp_all,
    aws_compliance.control.vpc_security_group_restricted_common_ports,
    aws_compliance.control.vpc_subnet_auto_assign_public_ip_disabled,
    aws_compliance.control.waf_regional_rule_condition_attached,
    aws_compliance.control.waf_web_acl_resource_associated,
    control.ec2_instance_not_use_multiple_enis,
    control.networkfirewall_firewall_policy_default_stateless_action_check_fragmented_packets,
    control.networkfirewall_firewall_policy_default_stateless_action_check_full_packets,
    control.networkfirewall_firewall_policy_rule_group_not_empty,
    control.networkfirewall_stateless_rule_group_not_empty,
    control.waf_regional_rule_group_rule_attached,
    control.waf_regional_web_acl_rule_attached
  ]

  tags = merge(local.security_common_tags, {
    type = "Benchmark"
  })
}

benchmark "security_6" {
  title       = "SEC 6: How do you protect your compute resources?"
  description = "Compute resources in your workload require multiple layers of defense to help protect from external and internal threats. Compute resources include EC2 instances, containers, AWS Lambda functions, database services, IoT devices, and more."
  children = [
    aws_compliance.control.cloudtrail_security_trail_enabled,
    aws_compliance.control.cloudtrail_trail_validation_enabled,
    aws_compliance.control.ebs_attached_volume_delete_on_termination_enabled,
    aws_compliance.control.ebs_attached_volume_encryption_enabled,
    aws_compliance.control.ec2_instance_iam_profile_attached,
    aws_compliance.control.ec2_instance_not_publicly_accessible,
    aws_compliance.control.ec2_instance_ssm_managed,
    aws_compliance.control.ec2_instance_uses_imdsv2,
    aws_compliance.control.ec2_stopped_instance_30_days,
    aws_compliance.control.ecr_repository_image_scan_on_push_enabled,
    aws_compliance.control.emr_cluster_master_nodes_no_public_ip,
    aws_compliance.control.lambda_function_concurrent_execution_limit_configured,
    aws_compliance.control.lambda_function_dead_letter_queue_configured,
    aws_compliance.control.lambda_function_in_vpc,
    aws_compliance.control.lambda_function_restrict_public_access,
    aws_compliance.control.rds_db_instance_automatic_minor_version_upgrade_enabled,
    aws_compliance.control.redshift_cluster_maintenance_settings_check,
    aws_compliance.control.ssm_managed_instance_compliance_association_compliant,
    aws_compliance.control.ssm_managed_instance_compliance_patch_compliant,
    aws_compliance.control.vpc_security_group_associated_to_eni,
    control.ec2_instance_not_use_multiple_enis,
    control.ecs_cluster_container_insights_enabled,
    control.ecs_service_fargate_using_latest_platform_version,
    control.lambda_function_multiple_az_configured,
    control.lambda_function_use_latest_runtime
  ]

  tags = merge(local.security_common_tags, {
    type = "Benchmark"
  })
}

benchmark "security_7" {
  title       = "SEC 7: How do you classify your data?"
  description = "Classification provides a way to categorize data, based on criticality and sensitivity in order to help you determine appropriate protection and retention controls."
  children = [
    aws_compliance.control.cloudwatch_log_group_retention_period_365,
    aws_compliance.control.guardduty_finding_archived
  ]

  tags = merge(local.security_common_tags, {
    type = "Benchmark"
  })
}

benchmark "security_8" {
  title       = "SEC 8: How do you protect your data at rest?"
  description = "Protect your data at rest by implementing multiple controls, to reduce the risk of unauthorized access or mishandling."
  children = [
    aws_compliance.control.account_part_of_organizations,
    aws_compliance.control.apigateway_stage_cache_encryption_at_rest_enabled,
    aws_compliance.control.backup_recovery_point_encryption_enabled,
    aws_compliance.control.cloudtrail_trail_logs_encrypted_with_kms_cmk,
    aws_compliance.control.codebuild_project_artifact_encryption_enabled,
    aws_compliance.control.codebuild_project_s3_logs_encryption_enabled,
    aws_compliance.control.dynamodb_table_encrypted_with_kms,
    aws_compliance.control.ebs_attached_volume_encryption_enabled,
    aws_compliance.control.ec2_ebs_default_encryption_enabled,
    aws_compliance.control.efs_file_system_encrypted_with_cmk,
    aws_compliance.control.es_domain_encryption_at_rest_enabled,
    aws_compliance.control.kms_key_not_pending_deletion,
    aws_compliance.control.log_group_encryption_at_rest_enabled,
    aws_compliance.control.opensearch_domain_encryption_at_rest_enabled,
    aws_compliance.control.rds_db_instance_encryption_at_rest_enabled,
    aws_compliance.control.rds_db_snapshot_encrypted_at_rest,
    aws_compliance.control.redshift_cluster_encryption_logging_enabled,
    aws_compliance.control.redshift_cluster_kms_enabled,
    aws_compliance.control.s3_bucket_default_encryption_enabled,
    aws_compliance.control.s3_bucket_default_encryption_enabled_kms,
    aws_compliance.control.s3_bucket_restrict_public_read_access,
    aws_compliance.control.s3_bucket_restrict_public_write_access,
    aws_compliance.control.s3_bucket_versioning_enabled,
    aws_compliance.control.s3_public_access_block_account,
    aws_compliance.control.s3_public_access_block_bucket,
    aws_compliance.control.sagemaker_endpoint_configuration_encryption_at_rest_enabled,
    aws_compliance.control.sagemaker_notebook_instance_encryption_at_rest_enabled,
    aws_compliance.control.secretsmanager_secret_encrypted_with_kms_cmk,
    aws_compliance.control.sns_topic_encrypted_at_rest
  ]

  tags = merge(local.security_common_tags, {
    type = "Benchmark"
  })
}

benchmark "security_9" {
  title       = "SEC 9: How do you protect your data in transit?"
  description = "Protect your data in transit by implementing multiple controls to reduce the risk of unauthorized access or loss."
  children = [
    aws_compliance.control.acm_certificate_expires_30_days,
    aws_compliance.control.apigateway_rest_api_stage_use_ssl_certificate,
    aws_compliance.control.elb_application_lb_drop_http_headers,
    aws_compliance.control.elb_application_lb_redirect_http_request_to_https,
    aws_compliance.control.elb_application_network_lb_use_ssl_certificate,
    aws_compliance.control.elb_classic_lb_use_ssl_certificate,
    aws_compliance.control.elb_classic_lb_use_tls_https_listeners,
    aws_compliance.control.es_domain_node_to_node_encryption_enabled,
    aws_compliance.control.guardduty_enabled,
    aws_compliance.control.opensearch_domain_https_required,
    aws_compliance.control.opensearch_domain_node_to_node_encryption_enabled,
    aws_compliance.control.redshift_cluster_encryption_in_transit_enabled,
    aws_compliance.control.s3_bucket_enforces_ssl,
    aws_compliance.control.vpc_flow_logs_enabled
  ]

  tags = merge(local.security_common_tags, {
    type = "Benchmark"
  })
}
