locals {
  conformance_pack_ec2_common_tags = merge(local.aws_compliance_common_tags, {
    service = "AWS/EC2"
  })
}

control "ec2_instance_not_use_multiple_enis" {
  title       = "EC2 instances should not use multiple ENIs"
  description = "This control checks whether an EC2 instance uses multiple Elastic Network Interfaces (ENIs) or Elastic Fabric Adapters (EFAs). This control passes if a single network adapter is used. The control includes an optional parameter list to identify the allowed ENIs."
  query       = query.ec2_instance_not_use_multiple_eni

  tags = merge(local.conformance_pack_ec2_common_tags, {
    well_architected = "true"
  })
}

query "ec2_instance_not_use_multiple_eni" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when jsonb_array_length(network_interfaces) = 1 then 'ok'
        else 'alarm'
      end as status,
      title || ' has ' || jsonb_array_length(network_interfaces) || ' ENI(s) attached.'
      as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_ec2_instance;
  EOQ
}