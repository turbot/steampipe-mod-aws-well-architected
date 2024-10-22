locals {
  well_architected_framework_rel09_common_tags = merge(local.well_architected_framework_reliability_common_tags, {
    question_id = "backing-up-data"
  })
}

benchmark "well_architected_framework_rel09" {
  title       = "REL09 How do you back up data?"
  description = "Back up data, applications, and configuration to meet your requirements for recovery time objectives (RTO) and recovery point objectives (RPO)."
  children = [
    benchmark.well_architected_framework_rel09_bp02,
    benchmark.well_architected_framework_rel09_bp03
  ]

  tags = local.well_architected_framework_rel09_common_tags
}

benchmark "well_architected_framework_rel09_bp02" {
  title       = "BP02 Secure and encrypt backups"
  description = "Control and detect access to backups using authentication and authorization. Prevent and detect if data integrity of backups is compromised using encryption."
  children = [
    aws_compliance.control.backup_recovery_point_encryption_enabled,
    aws_compliance.control.dynamodb_table_encryption_enabled,
    aws_compliance.control.ec2_ebs_default_encryption_enabled,
    aws_compliance.control.ebs_volume_encryption_at_rest_enabled,
    aws_compliance.control.rds_db_instance_encryption_at_rest_enabled,
    aws_compliance.control.rds_db_snapshot_encrypted_at_rest,
    aws_compliance.control.s3_bucket_default_encryption_enabled
  ]

  tags = merge(local.well_architected_framework_rel09_common_tags, {
    choice_id = "rel_backing_up_data_secured_backups_data"
    risk      = "high"
  })
}

benchmark "well_architected_framework_rel09_bp03" {
  title       = "BP03 Perform data backup automatically"
  description = "Control and detect access to backups using authentication and authorization. Prevent and detect if data integrity of backups is compromised using encryption."
  children = [
    aws_compliance.control.backup_recovery_point_manual_deletion_disabled,
    aws_compliance.control.backup_recovery_point_min_retention_35_days,
    aws_compliance.control.dynamodb_table_in_backup_plan,
    aws_compliance.control.dynamodb_table_point_in_time_recovery_enabled,
    aws_compliance.control.dynamodb_table_protected_by_backup_plan,
    aws_compliance.control.ec2_instance_protected_by_backup_plan,
    aws_compliance.control.elasticache_redis_cluster_automatic_backup_retention_15_days,
    aws_compliance.control.fsx_file_system_protected_by_backup_plan,
    aws_compliance.control.rds_db_cluster_aurora_backtracking_enabled,
    aws_compliance.control.rds_db_cluster_aurora_protected_by_backup_plan,
    aws_compliance.control.rds_db_instance_backup_enabled
  ]

  tags = merge(local.well_architected_framework_rel09_common_tags, {
    choice_id = "rel_backing_up_data_automated_backups_data"
    risk      = "high"
  })
}
