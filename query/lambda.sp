locals {
  conformance_pack_lambda_common_tags = merge(local.aws_compliance_common_tags, {
    service = "AWS/Lambda"
  })
}

control "lambda_function_use_latest_runtime" {
  title       = "Lambda functions should use latest runtimes"
  description = "This control checks that the lambda function settings for runtimes match the expected values set for the latest runtimes for each supported language. This control checks for the following runtimes: nodejs14.x, nodejs12.x, nodejs10.x, python3.8, python3.7, python3.6, ruby2.7, ruby2.5,java11, java8, go1.x, dotnetcore3.1, dotnetcore2.1."
  query       = query.lambda_function_uses_latest_runtime

  tags = merge(local.conformance_pack_lambda_common_tags, {
    well_architected = "true"
  })
}

control "lambda_function_multiple_az_configured" {
  title       = "Lambda functions should operate in more than one availability zone"
  description = "This control checks if lambda has more than one availability zone associated. The rule fails if only one availability zone is associated with lambda."
  query       = query.lambda_function_multiple_az

  tags = merge(local.conformance_pack_lambda_common_tags, {
    well_architected = "true"
  })
}

query "lambda_function_uses_latest_runtime" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when package_type <> 'Zip' then 'skip'
        when runtime in ('nodejs16.x', 'nodejs14.x', 'nodejs12.x', 'nodejs10.x', 'python3.9', 'python3.8', 'python3.7', 'python3.6', 'ruby2.5', 'ruby2.7', 'java11', 'java8', 'java8.al2', 'go1.x', 'dotnetcore2.1', 'dotnetcore3.1', 'dotnet6') then 'ok'
        else 'alarm'
      end as status,
      case
        when package_type <> 'Zip' then title || ' package type is ' || package_type || '.'
        when runtime in ('nodejs16.x', 'nodejs14.x', 'nodejs12.x', 'nodejs10.x', 'python3.9', 'python3.8', 'python3.7', 'python3.6', 'ruby2.5', 'ruby2.7', 'java11', 'java8', 'java8.al2', 'go1.x', 'dotnetcore2.1', 'dotnetcore3.1', 'dotnet6') then title || ' uses latest runtime - ' || runtime || '.'
        else title || ' uses ' || runtime || ' which is not the latest version.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_lambda_function;
  EOQ
}

query "lambda_function_multiple_az" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when vpc_id is null then 'skip'
        else case
          when
          (
            select
              count(distinct availability_zone_id)
            from
              aws_vpc_subnet
            where
              subnet_id in (select jsonb_array_elements_text(vpc_subnet_ids) )
          ) >= 2
          then 'ok'
          else 'alarm'
        end
      end as status,
      case
        when vpc_id is null then title || ' is not in VPC.'
        else title || ' has ' || jsonb_array_length(vpc_subnet_ids) || ' availability zone(s).'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_lambda_function;
  EOQ
}
