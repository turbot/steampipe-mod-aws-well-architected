locals {
  conformance_pack_vpc_common_tags = merge(local.aws_compliance_common_tags, {
    service = "AWS/VPC"
  })
}

control "vpc_peering_dns_resolution_check" {
  title       = "VPC peering DNS resolution from accepter/requester VPC to private IP should be enabled"
  description = "This control checks if DNS resolution from accepter/requester VPC to private IP is enabled. The rule is non compliant if DNS resolution from accepter/requester VPC to private IP is not enabled."
  query       = query.vpc_peering_dns_resolution_check

  tags = merge(local.conformance_pack_vpc_common_tags, {
    well_architected = "true"
  })
}

query "vpc_peering_dns_resolution_check" {
  sql = <<-EOQ
    select
      id as resource,
      case
        when requester_peering_options ->> 'AllowDnsResolutionFromRemoteVpc' = 'true' or accepter_peering_options -> 'AllowDnsResolutionFromRemoteVpc' = 'true' then 'ok'
        else 'alarm'
      end as status,
      case
        when requester_peering_options ->> 'AllowDnsResolutionFromRemoteVpc' = 'true' or accepter_peering_options -> 'AllowDnsResolutionFromRemoteVpc' = 'true' then title || ' DNS resolution enabled.'
        else title || ' DNS resolution disabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_vpc_peering_connection;
  EOQ
}