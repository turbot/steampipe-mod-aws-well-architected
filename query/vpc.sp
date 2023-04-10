locals {
  conformance_pack_vpc_common_tags = merge(local.aws_compliance_common_tags, {
    service = "AWS/VPC"
  })
}

control "vpc_network_acl_remote_administration" {
  title       = "Network ACLs should not allow ingress from 0.0.0.0/0 to port 22 or port 3389"
  description = "The Network Access Control List (NACL) function provide stateless filtering of ingress and egress network traffic to AWS resources. It is recommended that no NACL allows unrestricted ingress access to remote server administration ports, such as SSH to port 22 and RDP to port 3389."
  query       = query.vpc_network_acl_remote_administrations

  tags = merge(local.conformance_pack_vpc_common_tags, {
    well_architected = "true"
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

query "vpc_network_acl_remote_administrations" {
  sql = <<-EOQ
    with bad_rules as (
      select
        network_acl_id,
        count(*) as num_bad_rules
      from
        aws_vpc_network_acl,
        jsonb_array_elements(entries) as att
      where
        att ->> 'Egress' = 'false' -- as per aws egress = false indicates the ingress
        and (
          att ->> 'CidrBlock' = '0.0.0.0/0'
          or att ->> 'Ipv6CidrBlock' =  '::/0'
        )
        and att ->> 'RuleAction' = 'allow'
        and (
          (
            att ->> 'Protocol' = '-1' -- all traffic
            and att ->> 'PortRange' is null
          )
          or (
            (att -> 'PortRange' ->> 'From') :: int <= 22
            and (att -> 'PortRange' ->> 'To') :: int >= 22
            and att ->> 'Protocol' in('6', '17')  -- TCP or UDP
          )
          or (
            (att -> 'PortRange' ->> 'From') :: int <= 3389
            and (att -> 'PortRange' ->> 'To') :: int >= 3389
            and att ->> 'Protocol' in('6', '17')  -- TCP or UDP
        )
      )
      group by
        network_acl_id
    )
    select
      'arn:' || acl.partition || ':ec2:' || acl.region || ':' || acl.account_id || ':network-acl/' || acl.network_acl_id  as resource,
      case
        when bad_rules.network_acl_id is null then 'ok'
        else 'alarm'
      end as status,
      case
        when bad_rules.network_acl_id is null then acl.network_acl_id || ' does not allow ingress to port 22 or 3389 from 0.0.0.0/0 or ::/0.'
        else acl.network_acl_id || ' contains ' || bad_rules.num_bad_rules || ' rule(s) allowing ingress to port 22 or 3389 from 0.0.0.0/0 or ::/0.'
      end as reason
      ${local.tag_dimensions_sql}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "acl.")}
    from
      aws_vpc_network_acl as acl
      left join bad_rules on bad_rules.network_acl_id = acl.network_acl_id;
  EOQ
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