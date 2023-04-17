locals {
  conformance_pack_efs_common_tags = merge(local.aws_well_architected_common_tags, {
    service = "AWS/EFS"
  })
}

control "efs_access_point_enforces_user_identity" {
  title       = "EFS access points should enforce a user identity"
  description = "This control checks whether EFS access points are configured to enforce a user identity. This control fails if a POSIX user identity is not defined while creating the EFS access point."
  query       = query.efs_access_point_enforces_user_identity

  tags = merge(local.conformance_pack_efs_common_tags, {
    well_architected = "true"
  })
}

query "efs_access_point_enforces_user_identity" {
  sql = <<-EOQ
    select
      access_point_arn as resource,
      case
        when posix_user is null then 'alarm'
        else 'ok'
      end as status,
      case
        when posix_user is null then title || ' does not enforce a user identity.'
        else title || ' enforces a user identity.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_efs_access_point;
  EOQ
}
