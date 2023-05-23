locals {
  conformance_pack_ecs_common_tags = merge(local.aws_well_architected_common_tags, {
    service = "AWS/ECS"
  })
}

control "ecs_task_definition_non_root_user" {
  title       = "ECS task definitions should not use root user to run EC2 launch type containers"
  description = "This control checks if ECS Task Definitions specify a user for Elastic Container Service (ECS) EC2 launch type containers to run on. The rule is non compliant if the 'user' parameter is not present or set to 'root'."
  query       = query.ecs_task_definition_non_root_user

  tags = merge(local.conformance_pack_ecs_common_tags, {
    well_architected = "true"
  })
}

query "ecs_task_definition_non_root_user" {
  sql = <<-EOQ
    select
      task_definition_arn as resource,
      case
        when c ->> 'User' is null then 'alarm'
        when c ->> 'User' = 'root' then 'alarm'
        else 'ok'
      end as status,
      case
        when c ->> 'User' is null then title || ' user not set.'
        when c ->> 'User' = 'root' then title || ' uses root user to run EC2 launch type containers.'
        else title || ' uses non-root user to run EC2 launch type containers.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_ecs_task_definition,
      jsonb_array_elements(container_definitions) as c;
  EOQ
}
