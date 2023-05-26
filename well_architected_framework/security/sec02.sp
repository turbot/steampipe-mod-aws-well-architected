locals {
  well_architected_framework_sec02_common_tags = merge(local.well_architected_framework_security_common_tags, {
    question_id = "identities"
  })
}

benchmark "well_architected_framework_sec02" {
  title       = "SEC02 How do you manage identities for people and machines?"
  description = "There are two types of identities you need to manage when approaching operating secure AWS workloads. Understanding the type of identity you need to manage and grant access helps you ensure the right identities have access to the right resources under the right conditions. Human Identities: Your administrators, developers, operators, and end users require an identity to access your AWS environments and applications. These are members of your organization, or external users with whom you collaborate, and who interact with your AWS resources via a web browser, client application, or interactive command-line tools. Machine Identities: Your service applications, operational tools, and workloads require an identity to make requests to AWS services - for example, to read data. These identities include machines running in your AWS environment such as Amazon EC2 instances or AWS Lambda functions. You may also manage machine identities for external parties who need access. Additionally, you may also have machines outside of AWS that need access to your AWS environment."
  children = [
    benchmark.well_architected_framework_sec02_bp01,
    benchmark.well_architected_framework_sec02_bp02,
    benchmark.well_architected_framework_sec02_bp03,
    benchmark.well_architected_framework_sec02_bp05
  ]

  tags = local.well_architected_framework_sec02_common_tags
}

benchmark "well_architected_framework_sec02_bp01" {
  title       = "BP01 Use strong sign-in mechanisms"
  description = "Sign-ins (authentication using sign-in credentials) can present risks when not using mechanisms like multi-factor authentication (MFA), especially in situations where sign-in credentials have been inadvertently disclosed or are easily guessed. Use strong sign-in mechanisms to reduce these risks by requiring MFA and strong password policies."
  children = [
    // TODO: Should we add a control that uses the query iam_root_last_used?
    aws_compliance.control.iam_account_password_policy_strong_min_reuse_24,
    aws_compliance.control.iam_user_hardware_mfa_enabled,
    aws_compliance.control.iam_user_mfa_enabled,
    aws_compliance.control.iam_user_console_access_mfa_enabled,
    aws_compliance.control.iam_root_user_no_access_keys,
    aws_compliance.control.iam_user_with_administrator_access_mfa_enabled,
    aws_compliance.control.sagemaker_notebook_instance_root_access_disabled
  ]

  tags = merge(local.well_architected_framework_sec02_common_tags, {
    choice_id = "sec_identities_enforce_mechanisms"
    severity  = "high"
  })
}

benchmark "well_architected_framework_sec02_bp02" {
  title       = "BP02 Use temporary credentials"
  description = "When doing any type of authentication, it’s best to use temporary credentials instead of long-term credentials to reduce or eliminate risks, such as credentials being inadvertently disclosed, shared, or stolen."
  children = [
    aws_compliance.control.iam_user_access_key_age_90,
    aws_compliance.control.iam_user_unused_credentials_90,
    aws_compliance.control.secretsmanager_secret_automatic_rotation_enabled,
    aws_compliance.control.secretsmanager_secret_last_changed_90_day,
    aws_compliance.control.secretsmanager_secret_rotated_as_scheduled,
    aws_compliance.control.secretsmanager_secret_unused_90_day
  ]

  tags = merge(local.well_architected_framework_sec02_common_tags, {
    choice_id = "sec_identities_unique"
    severity  = "high"
  })
}

benchmark "well_architected_framework_sec02_bp03" {
  title       = "BP03 Store and use secrets securely"
  description = "A workload requires an automated capability to prove its identity to databases, resources, and third-party services. This is accomplished using secret access credentials, such as API access keys, passwords, and OAuth tokens. Using a purpose-built service to store, manage, and rotate these credentials helps reduce the likelihood that those credentials become compromised."
  children = [
    aws_compliance.control.cloudformation_stack_output_no_secrets,
    aws_compliance.control.ec2_instance_user_data_no_secrets,
    aws_compliance.control.ecs_task_definition_container_environment_no_secret
  ]

  tags = merge(local.well_architected_framework_sec02_common_tags, {
    choice_id = "sec_identities_secrets"
    severity  = "high"
  })
}

benchmark "well_architected_framework_sec02_bp05" {
  title       = "BP05 Audit and rotate credentials periodically"
  description = "Audit and rotate credentials periodically to limit how long the credentials can be used to access your resources. Long-term credentials create many risks, and these risks can be reduced by rotating long-term credentials regularly."
  children = [
    aws_compliance.control.iam_user_access_key_age_90,
    aws_compliance.control.kms_cmk_rotation_enabled,
    aws_compliance.control.secretsmanager_secret_automatic_rotation_enabled
  ]

  tags = merge(local.well_architected_framework_sec02_common_tags, {
    choice_id = "sec_identities_audit"
    severity  = "medium"
  })
}
