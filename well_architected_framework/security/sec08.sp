locals {
  well_architected_framework_sec08_common_tags = merge(local.well_architected_framework_security_common_tags, {
    question_id = "protect-data-rest"
  })
}

benchmark "well_architected_framework_sec08" {
  title       = "SEC08 How do you protect your data at rest?"
  description = "Protect your data at rest by implementing multiple controls, to reduce the risk of unauthorized access or mishandling."
  children = [
    benchmark.well_architected_framework_sec08_bp01,
    benchmark.well_architected_framework_sec08_bp02,
    benchmark.well_architected_framework_sec08_bp03,
    benchmark.well_architected_framework_sec08_bp04
  ]

  tags = local.well_architected_framework_sec08_common_tags
}

benchmark "well_architected_framework_sec08_bp01" {
  title       = "BP01 Implement secure key management"
  description = "By defining an encryption approach that includes the storage, rotation, and access control of keys, you can help provide protection for your content against unauthorized users and against unnecessary exposure to authorized users. AWS Key Management Service (AWS KMS) helps you manage encryption keys and integrates with many AWS services. This service provides durable, secure, and redundant storage for your AWS KMS keys. You can define your key aliases as well as key-level policies. The policies help you define key administrators as well as key users. Additionally, AWS CloudHSM is a cloud-based hardware security module (HSM) that allows you to easily generate and use your own encryption keys in the AWS Cloud. It helps you meet corporate, contractual, and regulatory compliance requirements for data security by using FIPS 140-2 Level 3 validated HSMs."
  children = [
    aws_compliance.control.apigateway_stage_cache_encryption_at_rest_enabled,
    aws_compliance.control.backup_recovery_point_encryption_enabled,
    aws_compliance.control.codebuild_project_artifact_encryption_enabled,
    aws_compliance.control.codebuild_project_s3_logs_encryption_enabled,
    aws_compliance.control.kms_key_not_pending_deletion
  ]

  tags = merge(local.well_architected_framework_sec08_common_tags, {
    choice_id = "sec_protect_data_rest_key_mgmt"
    severity  = "high"
  })
}

benchmark "well_architected_framework_sec08_bp02" {
  title       = "BP02 Enforce encryption at rest"
  description = "You should enforce the use of encryption for data at rest. Encryption maintains the confidentiality of sensitive data in the event of unauthorized access or accidental disclosure. Private data should be encrypted by default when at rest. Encryption helps maintain confidentiality of the data and provides an additional layer of protection against intentional or inadvertent data disclosure or exfiltration. Data that is encrypted cannot be read or accessed without first unencrypting the data. Any data stored unencrypted should be inventoried and controlled."
  children = [
    aws_compliance.control.efs_file_system_encrypt_data_at_rest,
    aws_compliance.control.es_domain_encryption_at_rest_enabled,
    aws_compliance.control.opensearch_domain_encryption_at_rest_enabled,
    aws_compliance.control.rds_db_instance_encryption_at_rest_enabled,
    aws_compliance.control.rds_db_snapshot_encrypted_at_rest,
    aws_compliance.control.cloudtrail_trail_logs_encrypted_with_kms_cmk,
    aws_compliance.control.dynamodb_table_encryption_enabled,
    aws_compliance.control.ec2_ebs_default_encryption_enabled,
    aws_compliance.control.eks_cluster_secrets_encrypted,
    // aws_compliance.control.glue_data_catalog_encryption_settings_password_encryption_enabled,
    // aws_compliance.control.glue_data_catalog_encryption_settings_metadata_encryption_enabled,
    aws_compliance.control.glue_dev_endpoint_cloudwatch_logs_encryption_enabled,
    aws_compliance.control.glue_dev_endpoint_job_bookmarks_encryption_enabled,
    aws_compliance.control.glue_dev_endpoint_s3_encryption_enabled,
    aws_compliance.control.glue_job_s3_encryption_enabled,
    aws_compliance.control.glue_job_bookmarks_encryption_enabled,
    aws_compliance.control.glue_job_cloudwatch_logs_encryption_enabled,
    aws_compliance.control.sagemaker_notebook_instance_encrypted_with_kms_cmk,
    aws_compliance.control.sagemaker_training_job_inter_container_traffic_encryption_enabled,
    aws_compliance.control.sagemaker_training_job_volume_and_data_encryption_enabled,
    aws_compliance.control.foundational_security_sqs_1
  ]

  tags = merge(local.well_architected_framework_sec08_common_tags, {
    choice_id = "sec_protect_data_rest_encrypt"
    severity  = "high"
  })
}

benchmark "well_architected_framework_sec08_bp03" {
  title       = "BP03 Automate data at rest protection"
  description = "Use automated tools to validate and enforce data at rest controls continuously, for example, verify that there are only encrypted storage resources. You can automate validation that all EBS volumes are encrypted using AWS Config Rules. AWS Security Hub can also verify several different controls through automated checks against security standards. Additionally, your AWS Config Rules can automatically remediate noncompliant resources."
  children = [
    aws_compliance.control.redshift_cluster_audit_logging_enabled,
    aws_compliance.control.redshift_cluster_kms_enabled,
    aws_compliance.control.s3_bucket_default_encryption_enabled,
    aws_compliance.control.sagemaker_endpoint_configuration_encryption_at_rest_enabled,
    aws_compliance.control.sagemaker_notebook_instance_encryption_at_rest_enabled,
    aws_compliance.control.sagemaker_notebook_instance_encrypted_with_kms_cmk
  ]

  tags = merge(local.well_architected_framework_sec08_common_tags, {
    choice_id = "sec_protect_data_rest_automate_protection"
    severity  = "medium"
  })
}

benchmark "well_architected_framework_sec08_bp04" {
  title       = "BP04 Enforce access control"
  description = "To help protect your data at rest, enforce access control using mechanisms, such as isolation and versioning, and apply the principle of least privilege. Prevent the granting of public access to your data. Verify that only authorized users can access data on a need-to-know basis. Protect your data with regular backups and versioning to prevent against intentional or inadvertent modification or deletion of data. Isolate critical data from other data to protect its confidentiality and data integrity."
  children = [
    aws_compliance.control.sns_topic_encrypted_at_rest,
    aws_compliance.control.s3_bucket_versioning_enabled,
    aws_compliance.control.account_part_of_organizations
  ]

  tags = merge(local.well_architected_framework_sec08_common_tags, {
    choice_id = "sec_protect_data_rest_access_control"
    severity  = "low"
  })
}
