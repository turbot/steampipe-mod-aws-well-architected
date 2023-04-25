locals {
  conformance_pack_opensearch_common_tags = merge(local.aws_well_architected_common_tags, {
    service = "AWS/OpenSearch"
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

