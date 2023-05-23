locals {
  well_architected_framework_security_common_tags = merge(local.well_architected_framework_common_tags, {
    pillar = "security"
  })
}

locals {
  well_architected_framework_security_1_common_tags = merge(local.well_architected_framework_security_common_tags, {
    question_id = "securely-operate"
  })
  well_architected_framework_security_2_common_tags = merge(local.well_architected_framework_security_common_tags, {
    question_id = "identities"
  })
}


benchmark "well_architected_framework_security" {
  title       = "Security Pillar"
  description = "The security pillar focuses on protecting information and systems. Key topics include confidentiality and integrity of data, managing user permissions, and establishing controls to detect security events."
  children = [
    benchmark.well_architected_framework_security_1,
    benchmark.well_architected_framework_security_2
  ]

  tags = local.well_architected_framework_security_common_tags
}

benchmark "well_architected_framework_security_1" {
  title       = "SEC 1: How do you securely operate your workload?"
  description = "To operate your workload securely, you must apply overarching best practices to every area of security. Take requirements and processes that you have defined in operational excellence at an organizational and workload level, and apply them to all areas. Staying up to date with AWS and industry recommendations and threat intelligence helps you evolve your threat model and control objectives. Automating security processes, testing, and validation allow you to scale your security operations."
  children = [
    benchmark.well_architected_framework_security_1_sec_securely_operate_multi_accounts,
    benchmark.well_architected_framework_security_1_sec_securely_operate_aws_account
  ]

  tags = local.well_architected_framework_security_1_common_tags
}


benchmark "well_architected_framework_security_1_sec_securely_operate_multi_accounts" {
  title       = "Separate workloads using accounts"
  description = "Establish common guardrails and isolation between environments (such as production, development, and test) and workloads through a multi-account strategy. Account-level separation is strongly recommended, as it provides a strong isolation boundary for security, billing, and access."
  children = [
    aws_compliance.control.account_part_of_organizations
  ]

  tags = merge(local.well_architected_framework_security_1_common_tags, {
    choice_id = "sec_securely_operate_multi_accounts"
    // TODO: How to determine severity?
    severity  = "high"
  })
}

benchmark "well_architected_framework_security_1_sec_securely_operate_aws_account" {
  title       = "Secure account root user and properties"
  description = "The root user is the most privileged user in an AWS account, with full administrative access to all resources within the account, and in some cases cannot be constrained by security policies. Disabling programmatic access to the root user, establishing appropriate controls for the root user, and avoiding routine use of the root user helps reduce the risk of inadvertent exposure of the root credentials and subsequent compromise of the cloud environment."
  children = [
    // TODO: Should we add a control that uses the query iam_root_last_used?
    aws_compliance.control.iam_root_user_hardware_mfa_enabled,
    aws_compliance.control.iam_root_user_mfa_enabled,
    aws_compliance.control.iam_root_user_no_access_keys
  ]

  tags = merge(local.well_architected_framework_security_1_common_tags, {
    choice_id = "sec_securely_operate_multi_accounts"
    // TODO: How to determine severity?
    severity  = "high"
  })
}

benchmark "well_architected_framework_security_2" {
  title       = "SEC 2: How do you manage authentication for people and machines?"
  description = "There are two types of identities you need to manage when approaching operating secure AWS workloads. Understanding the type of identity you need to manage and grant access helps you ensure the right identities have access to the right resources under the right conditions. Human Identities: Your administrators, developers, operators, and end users require an identity to access your AWS environments and applications. These are members of your organization, or external users with whom you collaborate, and who interact with your AWS resources via a web browser, client application, or interactive command-line tools. Machine Identities: Your service applications, operational tools, and workloads require an identity to make requests to AWS services - for example, to read data. These identities include machines running in your AWS environment such as Amazon EC2 instances or AWS Lambda functions. You may also manage machine identities for external parties who need access. Additionally, you may also have machines outside of AWS that need access to your AWS environment."
  children = [
    benchmark.well_architected_framework_security_2_sec_identities_enforce_mechanisms,
    benchmark.well_architected_framework_security_2_sec_identities_unique
  ]

  tags = local.well_architected_framework_security_2_common_tags
}

benchmark "well_architected_framework_security_2_sec_identities_enforce_mechanisms" {
  title       = "Use strong sign-in mechanisms"
  description = "Sign-ins (authentication using sign-in credentials) can present risks when not using mechanisms like multi-factor authentication (MFA), especially in situations where sign-in credentials have been inadvertently disclosed or are easily guessed. Use strong sign-in mechanisms to reduce these risks by requiring MFA and strong password policies."
  children = [
    // TODO: Should we add a control that uses the query iam_root_last_used?
    aws_compliance.control.iam_account_password_policy_strong_min_reuse_24,
    aws_compliance.control.iam_user_console_access_mfa_enabled,
    aws_compliance.control.iam_user_hardware_mfa_enabled,
    aws_compliance.control.iam_user_mfa_enabled,
    aws_compliance.control.iam_user_with_administrator_access_mfa_enabled,
    aws_compliance.control.sagemaker_notebook_instance_root_access_disabled
  ]

  tags = merge(local.well_architected_framework_security_2_common_tags, {
    choice_id = "sec_identities_enforce_mechanisms"
    // TODO: How to determine severity?
    severity  = "high"
  })
}

benchmark "well_architected_framework_security_2_sec_identities_unique" {
  title       = "Use temporary credentials"
  description = "When doing any type of authentication, it’s best to use temporary credentials instead of long-term credentials to reduce or eliminate risks, such as credentials being inadvertently disclosed, shared, or stolen."
  children = [
    aws_compliance.control.iam_user_access_key_age_90,
    aws_compliance.control.iam_user_unused_credentials_90,
    aws_compliance.control.secretsmanager_secret_automatic_rotation_enabled,
    aws_compliance.control.secretsmanager_secret_last_changed_90_day,
    aws_compliance.control.secretsmanager_secret_rotated_as_scheduled,
    aws_compliance.control.secretsmanager_secret_unused_90_day
  ]

  tags = merge(local.well_architected_framework_security_2_common_tags, {
    choice_id = "sec_identities_unique"
    // TODO: How to determine severity?
    severity  = "high"
  })
}
