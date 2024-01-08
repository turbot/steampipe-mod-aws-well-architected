locals {
  well_architected_framework_sec01_common_tags = merge(local.well_architected_framework_security_common_tags, {
    question_id = "securely-operate"
  })
}

benchmark "well_architected_framework_sec01" {
  title       = "SEC01 How do you securely operate your workload?"
  description = "To operate your workload securely, you must apply overarching best practices to every area of security. Take requirements and processes that you have defined in operational excellence at an organizational and workload level, and apply them to all areas. Staying up to date with AWS and industry recommendations and threat intelligence helps you evolve your threat model and control objectives. Automating security processes, testing, and validation allow you to scale your security operations."
  children = [
    benchmark.well_architected_framework_sec01_bp01,
    benchmark.well_architected_framework_sec01_bp02,
    benchmark.well_architected_framework_sec01_bp06,
    benchmark.well_architected_framework_sec01_bp08,
  ]

  tags = local.well_architected_framework_sec01_common_tags
}

benchmark "well_architected_framework_sec01_bp01" {
  title       = "BP01 Separate workloads using accounts"
  description = "Establish common guardrails and isolation between environments (such as production, development, and test) and workloads through a multi-account strategy. Account-level separation is strongly recommended, as it provides a strong isolation boundary for security, billing, and access."
  children = [
    aws_compliance.control.account_part_of_organizations
  ]

  tags = merge(local.well_architected_framework_sec01_common_tags, {
    choice_id = "sec_securely_operate_multi_accounts"
    risk  = "high"
  })
}

benchmark "well_architected_framework_sec01_bp02" {
  title       = "BP02 Secure account root user and properties"
  description = "The root user is the most privileged user in an AWS account, with full administrative access to all resources within the account, and in some cases cannot be constrained by security policies. Disabling programmatic access to the root user, establishing appropriate controls for the root user, and avoiding routine use of the root user helps reduce the risk of inadvertent exposure of the root credentials and subsequent compromise of the cloud environment."
  children = [
    // TODO: Should we add a control that uses the query iam_root_last_used?
    aws_compliance.control.iam_root_user_hardware_mfa_enabled,
    aws_compliance.control.iam_root_user_mfa_enabled,
    aws_compliance.control.iam_root_user_no_access_keys
  ]

  tags = merge(local.well_architected_framework_sec01_common_tags, {
    choice_id = "sec_securely_operate_multi_accounts"
    risk  = "high"
  })
}

benchmark "well_architected_framework_sec01_bp06" {
  title       = "BP06 Automate testing and validation of security controls in pipelines"
  description = "Establish secure baselines and templates for security mechanisms that are tested and validated as part of your build, pipelines, and processes. Use tools and automation to test and validate all security controls continuously."
  children = [
    aws_compliance.control.ec2_instance_ssm_managed,
    aws_compliance.control.ecr_repository_image_scan_on_push_enabled,
  ]

  tags = merge(local.well_architected_framework_sec01_common_tags, {
    choice_id = "sec_securely_operate_test_validate_pipeline"
    risk  = "medium"
  })
}

benchmark "well_architected_framework_sec01_bp08" {
  title       = "BP08 Evaluate and implement new security services and features regularly"
  description = "Evaluate and implement security services and features from AWS and AWS Partners that allow you to evolve the security posture of your workload. The AWS Security Blog highlights new AWS services and features, implementation guides, and general security guidance."
  children = [
    aws_compliance.control.codebuild_project_plaintext_env_variables_no_sensitive_aws_values,
  ]

  tags = merge(local.well_architected_framework_sec01_common_tags, {
    choice_id = "sec_securely_operate_implement_services_features"
    risk  = "low"
  })
}
