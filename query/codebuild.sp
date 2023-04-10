locals {
  conformance_pack_codebuild_common_tags = merge(local.aws_compliance_common_tags, {
    service = "AWS/CodeBuild"
  })
}

control "codebuild_project_s3_logs_encryption_enabled" {
  title       = "CodeBuild projects S3 logs should be encrypted"
  description = "This control checks if S3 logs for CodeBuild project are encrypted. The control fails if encryption is deactivated for S3 logs for a CodeBuild project."
  query       = query.codebuild_project_s3_logs_encryption

  tags = merge(local.conformance_pack_codebuild_common_tags, {
    well_architected = "true"
  })
}

query "codebuild_project_s3_logs_encryption" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when not (logs_config -> 'S3Logs' ->> 'EncryptionDisabled')::bool then 'ok'
        else 'alarm'
      end as status,
      case
        when not (logs_config -> 'S3Logs' ->> 'EncryptionDisabled')::bool then title || ' S3Logs encryption enabled.'
        else title || ' S3Logs encryption disabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_codebuild_project;
  EOQ
}