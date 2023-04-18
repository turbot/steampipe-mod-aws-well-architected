locals {
  conformance_pack_elb_common_tags = merge(local.aws_compliance_common_tags, {
    service = "AWS/ELB"
  })
}

control "elb_network_lb_cross_zone_load_balancing_enabled" {
  title       = "ELB network load balancers cross-zone load balancing should be enabled"
  description = "This control checks if cross-zone load balancing is enabled on Network Load Balancers (NLBs). The rule is non compliant if cross-zone load balancing is not enabled for an NLB."
  query       = query.elb_network_lb_cross_zone_load_balancing_enabled

  tags = merge(local.conformance_pack_elb_common_tags, {
    well_architected = "true"
  })
}

query "elb_network_lb_cross_zone_load_balancing_enabled" {
  sql = <<-EOQ
    with cross_zone_enabled_nlb as (
      select
        arn
      from
        aws_ec2_network_load_balancer,
        jsonb_array_elements(load_balancer_attributes) as a
      where
        a ->> 'Key' = 'load_balancing.cross_zone.enabled'
        and a ->> 'Value' = 'true'
    )
    select
      nlb.arn as resource,
      case
        when c.arn is null then 'alarm'
        else 'ok'
      end as status,
      case
        when c.arn is null then title || ' cross-zone load balancing disabled.'
        else title || ' cross-zone load balancing enabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_ec2_network_load_balancer as nlb
      left join cross_zone_enabled_nlb as c on c.arn = nlb.arn;
  EOQ
}
