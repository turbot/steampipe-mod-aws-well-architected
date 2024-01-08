locals {
  well_architected_framework_sec03_common_tags = merge(local.well_architected_framework_security_common_tags, {
    question_id = "permissions"
  })
}

benchmark "well_architected_framework_sec03" {
  title       = "SEC03 How do you manage permissions for people and machines?"
  description = "Manage permissions to control access to people and machine identities that require access to AWS and your workload. Permissions control who can access what, and under what conditions."
  children = [
    benchmark.well_architected_framework_sec03_bp01,
    benchmark.well_architected_framework_sec03_bp02,
    benchmark.well_architected_framework_sec03_bp03,
    benchmark.well_architected_framework_sec03_bp04,
    benchmark.well_architected_framework_sec03_bp05,
    benchmark.well_architected_framework_sec03_bp06,
    benchmark.well_architected_framework_sec03_bp07,
    benchmark.well_architected_framework_sec03_bp08
  ]

  tags = local.well_architected_framework_sec03_common_tags
}

benchmark "well_architected_framework_sec03_bp01" {
  title       = "BP01 Define access requirements"
  description = "Each component or resource of your workload needs to be accessed by administrators, end users, or other components. Have a clear definition of who or what should have access to each component, choose the appropriate identity type and method of authentication and authorization."
  children = [
    aws_compliance.control.ec2_instance_uses_imdsv2,
    aws_compliance.control.ec2_instance_iam_profile_attached,
    aws_compliance.control.ecs_task_definition_user_for_host_mode_check,
    aws_compliance.control.cloudwatch_cross_account_sharing
  ]

  tags = merge(local.well_architected_framework_sec03_common_tags, {
    choice_id = "sec_permissions_define"
    risk  = "high"
  })
}

benchmark "well_architected_framework_sec03_bp02" {
  title       = "BP02 Grant least privilege access"
  description = "It's a best practice to grant only the access that identities require to perform specific actions on specific resources under specific conditions. Use group and identity attributes to dynamically set permissions at scale, rather than defining permissions for individual users. Users should only have the permissions required to do their job. Users should only be given access to production environments to perform a specific task within a limited time period, and access should be revoked once that task is complete. Permissions should be revoked when no longer needed, including when a user moves onto a different project or job function. Administrator privileges should be given only to a small group of trusted administrators. Permissions should be reviewed regularly to avoid permission creep. Machine or system accounts should be given the smallest set of permissions needed to complete their tasks."
  children = [
    aws_compliance.control.ecs_task_definition_container_readonly_root_filesystem,
    aws_compliance.control.emr_cluster_kerberos_enabled,
    aws_compliance.control.ec2_instance_iam_profile_attached
  ]

  tags = merge(local.well_architected_framework_sec03_common_tags, {
    choice_id = "sec_permissions_least_privileges"
    risk  = "high"
  })
}

benchmark "well_architected_framework_sec03_bp03" {
  title       = "BP03 Establish emergency access process"
  description = "A process that allows emergency access to your workload in the unlikely event of an automated process or pipeline issue. This will help you rely on least privilege access, but ensure users can obtain the right level of access when they require it. For example, establish a process for administrators to verify and approve their request, such as an emergency AWS cross-account role for access, or a specific process for administrators to follow to validate and approve an emergency request."
  children = [
    aws_compliance.control.iam_group_not_empty,
    aws_compliance.control.iam_policy_custom_no_blocked_kms_actions
  ]

  tags = merge(local.well_architected_framework_sec03_common_tags, {
    choice_id = "sec_permissions_emergency_process"
    risk  = "high"
  })
}

benchmark "well_architected_framework_sec03_bp04" {
  title       = "BP04 Reduce permissions continuously"
  description = "As your teams determine what access is required, remove unneeded permissions and establish review processes to achieve least privilege permissions. Continually monitor and remove unused identities and permissions for both human and machine access. Permission policies should adhere to the least privilege principle. As job duties and roles become better defined, your permission policies need to be reviewed to remove unnecessary permissions. This approach lessens the scope of impact should credentials be inadvertently exposed or otherwise accessed without authorization."
  children = [
    aws_compliance.control.iam_policy_no_star_star,
  ]

  tags = merge(local.well_architected_framework_sec03_common_tags, {
    choice_id = "sec_permissions_continuous_reduction"
    risk  = "medium"
  })
}

benchmark "well_architected_framework_sec03_bp05" {
  title       = "BP05 Define permission guardrails for your organization"
  description = "Establish common controls that restrict access to all identities in your organization. For example, you can restrict access to specific AWS Regions, or prevent your operators from deleting common resources, such as an IAM role used for your central security team."
  children = [
    aws_compliance.control.account_part_of_organizations,
    aws_compliance.control.iam_user_unused_credentials_90,
  ]

  tags = merge(local.well_architected_framework_sec03_common_tags, {
    choice_id = "sec_permissions_define_guardrails"
    risk  = "medium"
  })
}

benchmark "well_architected_framework_sec03_bp06" {
  title       = "BP06 Manage access based on lifecycle"
  description = "Integrate access controls with operator and application lifecycle and your centralized federation provider. For example, remove a user's access when they leave the organization or change roles. AWS RAM, access to shared resources is automatically granted or revoked as accounts are moved in and out of the Organization or Organization Unit with which they are shared. This helps ensure that resources are only shared with the accounts that you intend."
  children = [
    aws_compliance.control.iam_user_unused_credentials_90,
    aws_compliance.control.dms_replication_instance_not_publicly_accessible,
    aws_compliance.control.cloudwatch_log_group_retention_period_365,
    aws_compliance.control.codebuild_project_build_greater_then_90_days,
    aws_compliance.control.vpc_eip_associated,
    aws_compliance.control.ecr_repository_lifecycle_policy_configured,
    aws_compliance.control.iam_password_policy_expire_90,
  ]

  tags = merge(local.well_architected_framework_sec03_common_tags, {
    choice_id = "sec_permissions_lifecycle"
    risk  = "low"
  })
}

benchmark "well_architected_framework_sec03_bp07" {
  title       = "BP07 Analyze public and cross-account access"
  description = "Continually monitor findings that highlight public and cross-account access. Reduce public access and cross-account access to only the specific resources that require this access. Know which of your AWS resources are shared and with whom. Continually monitor and audit your shared resources to verify they are shared with only authorized principals."
  children = [
    aws_compliance.control.dms_replication_instance_not_publicly_accessible,
    aws_compliance.control.ebs_snapshot_not_publicly_restorable,
    aws_compliance.control.ec2_instance_not_publicly_accessible,
    aws_compliance.control.es_domain_in_vpc,
    aws_compliance.control.opensearch_domain_in_vpc,
    aws_compliance.control.emr_cluster_master_nodes_no_public_ip,
    aws_compliance.control.emr_account_public_access_blocked,
    aws_compliance.control.ec2_instance_in_vpc,
    aws_compliance.control.lambda_function_restrict_public_access,
    aws_compliance.control.lambda_function_in_vpc,
    aws_compliance.control.rds_db_instance_prohibit_public_access,
    aws_compliance.control.rds_db_snapshot_prohibit_public_access,
    aws_compliance.control.kms_cmk_policy_prohibit_public_access,
    aws_compliance.control.redshift_cluster_prohibit_public_access,
    aws_compliance.control.s3_bucket_policy_restrict_public_access,
    aws_compliance.control.s3_bucket_restrict_public_write_access,
    aws_compliance.control.sagemaker_notebook_instance_direct_internet_access_disabled,
    aws_compliance.control.secretsmanager_secret_unused_90_day,
    aws_compliance.control.autoscaling_launch_config_public_ip_disabled,
    aws_compliance.control.cloudtrail_bucket_not_public,
    aws_compliance.control.ecr_repository_prohibit_public_access,
    aws_compliance.control.eks_cluster_endpoint_restrict_public_access,
    aws_compliance.control.elb_application_classic_network_lb_prohibit_public_access,
    aws_compliance.control.s3_public_access_block_account,
    aws_compliance.control.sns_topic_policy_prohibit_public_access,
    aws_compliance.control.sqs_queue_policy_prohibit_public_access,
    aws_compliance.control.ssm_document_prohibit_public_access
  ]

  tags = merge(local.well_architected_framework_sec03_common_tags, {
    choice_id = "sec_permissions_analyze_cross_account"
    risk  = "low"
  })
}

benchmark "well_architected_framework_sec03_bp08" {
  title       = "BP08 Share resources securely within your organization"
  description = "As the number of workloads grows, you might need to share access to resources in those workloads or provision the resources multiple times across multiple accounts. You might have constructs to compartmentalize your environment, such as having development, testing, and production environments. However, having separation constructs does not limit you from being able to share securely. By sharing components that overlap, you can reduce operational overhead and allow for a consistent experience without guessing what you might have missed while creating the same resource multiple times."
  children = [
    aws_compliance.control.dms_replication_instance_not_publicly_accessible,
    aws_compliance.control.es_domain_in_vpc,
    aws_compliance.control.opensearch_domain_in_vpc,
    aws_compliance.control.ec2_instance_in_vpc,
    aws_compliance.control.lambda_function_in_vpc,
    aws_compliance.control.sagemaker_notebook_instance_direct_internet_access_disabled,
    aws_compliance.control.secretsmanager_secret_unused_90_day,
    aws_compliance.control.codebuild_project_with_user_controlled_buildspec,
  ]

  tags = merge(local.well_architected_framework_sec03_common_tags, {
    choice_id = "sec_permissions_share_securely"
    risk  = "low"
  })
}
