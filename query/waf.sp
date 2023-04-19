locals {
  conformance_pack_waf_common_tags = merge(local.aws_compliance_common_tags, {
    service = "AWS/waf"
  })
}

control "waf_regional_web_acl_rule_attached" {
  title       = "WAF regional web ACL should have at least one rule or rule group attached"
  description = "This control checks if a WAF regional Web ACL contains any WAF rules or rule groups. The rule is non compliant if there are no WAF rules or rule groups present within a Web ACL."
  query       = query.waf_regional_web_acl_rule_attached

  tags = merge(local.conformance_pack_waf_common_tags, {
    well_architected       = "true"
  })
}

control "waf_regional_rule_group_rule_attached" {
  title       = "WAF regional rule group should have at least one rule attached"
  description = "This control checks if WAF regional rule groups contain any rules. The rule is non compliant if there are no rules present within a WAF regional rule group."
  query       = query.waf_regional_rule_group_rule_attached

  tags = merge(local.conformance_pack_waf_common_tags, {
    well_architected       = "true"
  })
}

query "waf_regional_web_acl_rule_attached" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when rules is null or jsonb_array_length(rules) = 0 then 'alarm'
        else 'ok'
      end as status,
      case
        when rules is null or jsonb_array_length(rules) = 0 then title || ' has no attached rules.'
        else title || ' has attached rules.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_wafregional_web_acl;
  EOQ
}

query "waf_regional_rule_group_rule_attached" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when activated_rules is null or jsonb_array_length(activated_rules) = 0 then 'alarm'
        else 'ok'
      end as status,
      case
        when activated_rules is null or jsonb_array_length(activated_rules) = 0 then title || ' has no attached rules.'
        else title || ' has attached rules.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_wafregional_rule_group;
  EOQ
}