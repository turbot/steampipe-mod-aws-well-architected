locals {
  conformance_pack_opensearch_common_tags = merge(local.aws_compliance_common_tags, {
    service = "AWS/OpenSearch"
  })
}

control "opensearch_domain_in_vpc" {
  title       = "OpenSearch domains should be in a VPC"
  description = "This control checks whether Amazon OpenSearch domains are in a VPC. It does not evaluate the VPC subnet routing configuration to determine public access."
  query       = query.opensearch_domains_in_vpc

  tags = merge(local.conformance_pack_opensearch_common_tags, {
    well_architected = "true"
  })
}

control "opensearch_domain_data_node_fault_tolerance" {
  title       = "OpenSearch domains data node should be fault tolerant"
  description = "This control checks if Amazon OpenSearch Service domains are configured with at least three data nodes and zoneAwarenessEnabled is true. The rule is non compliant for an OpenSearch domain if 'instanceCount' is less than 3 or 'zoneAwarenessEnabled' is set to 'false'."
  query       = query.opensearch_domain_data_node_fault_tolerance

  tags = merge(local.conformance_pack_opensearch_common_tags, {
    well_architected = "true"
  })
}

query "opensearch_domains_in_vpc" {
  sql = <<-EOQ
    with public_subnets as (
      select
        distinct a -> 'SubnetId' as SubnetId
      from
        aws_vpc_route_table as t,
        jsonb_array_elements(associations) as a,
        jsonb_array_elements(routes) as r
      where
        r ->> 'DestinationCidrBlock' = '0.0.0.0/0'
        and  r ->>  'GatewayId' like 'igw-%'
    ), opensearch_domain_with_public_subnet as (
      select
        arn
      from
        aws_opensearch_domain ,
        jsonb_array_elements(vpc_options -> 'SubnetIds') as s
      where
        s in (select SubnetId from public_subnets)
    )
    select
      d.arn as resource,
      case
        when d.vpc_options ->> 'VPCId' is null then 'alarm'
        when d.vpc_options ->> 'VPCId' is not null and p.arn is not null then 'alarm'
        else 'ok'
      end status,
      case
        when vpc_options ->> 'VPCId' is null then title || ' not in VPC.'
        when d.vpc_options ->> 'VPCId' is not null and p.arn is not null then title || ' attached to public subnet.'
        else title || ' in VPC ' || (vpc_options ->> 'VPCId') || '.'
      end reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "d.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "d.")}
    from
      aws_opensearch_domain as d left join opensearch_domain_with_public_subnet as p
      on d.arn = p.arn;
  EOQ
}

query "opensearch_domain_data_node_fault_tolerance" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when cluster_config ->> 'ZoneAwarenessEnabled' = 'true' and (cluster_config ->> 'InstanceCount') :: int >= 3 then 'ok'
        else 'alarm'
      end as status,
      case
        when cluster_config ->> 'ZoneAwarenessEnabled' = 'true' and (cluster_config ->> 'InstanceCount') :: int >= 3 then title || ' data node is fault tolerant.'
        else title || ' data node is fault intolerant.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_opensearch_domain;
  EOQ
}

