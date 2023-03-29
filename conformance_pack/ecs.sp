locals {
  conformance_pack_ecs_common_tags = merge(local.aws_compliance_common_tags, {
    service = "AWS/ECS"
  })
}

control "ecs_service_fargate_using_latest_platform_version" {
  title       = "ECS fargate services should run on the latest fargate platform version"
  description = "This control checks if Amazon ECS Fargate services are running the latest Fargate platform version. This control fails if the platform version is not the latest."
  query       = query.ecs_service_fargate_uses_latest_platform_version

  tags = merge(local.conformance_pack_ecs_common_tags, {
    well_architected = "true"
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

control "ecs_cluster_container_insights_enabled" {
  title       = "ECS clusters should have container insights enabled"
  description = "This control checks if ECS clusters use container insights. This control fails if container insights are not set up for a cluster."
  query       = query.ecs_cluster_container_insights

  tags = merge(local.conformance_pack_ecs_common_tags, {
    well_architected = "true"
  })
}

control "ecs_task_definition_container_readonly_root_filesystem" {
  title       = "ECS containers should be limited to read-only access to root filesystems"
  description = "This control checks if ECS containers are limited to read-only access to mounted root filesystems. This control fails if the 'ReadonlyRootFilesystem' parameter in the container definition of ECS task definitions is set to false."
  query       = query.ecs_task_definition_container_readonly_root_filesystems

  tags = merge(local.conformance_pack_ecs_common_tags, {
    well_architected = "true"
  })
}

control "ecs_task_definition_container_non_privileged" {
  title       = "ECS containers should run as non-privileged"
  description = "This control checks if the privileged parameter in the container definition of ECS task definitions is set to true. The control fails if this parameter is equal to true."
  query       = query.ecs_task_definition_container_non_privileg

  tags = merge(local.conformance_pack_ecs_common_tags, {
    well_architected = "true"
  })
}

query "ecs_service_fargate_uses_latest_platform_version" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when launch_type <> 'FARGATE' then 'skip'
        when platform_version = 'LATEST' then 'ok'
        else 'alarm'
      end as status,
      case
        when launch_type <> 'FARGATE' then title || ' is ' || launch_type || ' service.'
        when platform_version = 'LATEST' then title || ' running on the latest fargate platform version.'
        else title || ' not running on the latest fargate platform version.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_ecs_service;
  EOQ
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

query "ecs_cluster_container_insights" {
  sql = <<-EOQ
    select
      cluster_arn as resource,
      case
        when s ->> 'Name' = 'containerInsights' and s ->> 'Value' = 'enabled' then 'ok'
        else 'alarm'
      end as status,
      case
        when s ->> 'Name' = 'containerInsights' and s ->> 'Value' = 'enabled' then title || ' Container Insights enabled.'
        else title || ' Container Insights disabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_ecs_cluster as c,
      jsonb_array_elements(settings) as s;
  EOQ
}

query "ecs_task_definition_container_readonly_root_filesystems" {
  sql = <<-EOQ
    with privileged_container_definition as (
      select
        distinct task_definition_arn as arn
      from
        aws_ecs_task_definition,
        jsonb_array_elements(container_definitions) as c
      where
        c ->> 'ReadonlyRootFilesystem' = 'true'
    )
    select
      d.task_definition_arn as resource,
      case
        when c.arn is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when c.arn is not null then d.title || ' containers limited to read-only access to root filesystems.'
        else d.title || ' containers not limited to read-only access to root filesystems.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_ecs_task_definition as d
      left join privileged_container_definition as c on d.task_definition_arn = c.arn;
  EOQ
}

query "ecs_task_definition_container_non_privileg" {
  sql = <<-EOQ
    with privileged_container_definition as (
      select
        distinct task_definition_arn as arn
      from
        aws_ecs_task_definition,
        jsonb_array_elements(container_definitions) as c
      where
        c ->> 'Privileged' = 'true'
    )
    select
      d.task_definition_arn as resource,
      case
        when c.arn is null then 'ok'
        else 'alarm'
      end as status,
      case
        when c.arn is null then d.title || ' does not have elevated privileges.'
        else d.title || ' has elevated privileges.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_ecs_task_definition as d
      left join privileged_container_definition as c on d.task_definition_arn = c.arn;
  EOQ
}