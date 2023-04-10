locals {
  conformance_pack_apigateway_common_tags = merge(local.aws_well_architected_common_tags, {
    service = "AWS/APIGateway"
  })
}

control "apigateway_rest_api_stage_xray_tracing_enabled" {
  title       = "API Gateway REST API stages should have X-Ray tracing enabled"
  description = "This control checks whether X-Ray active tracing is enabled for your API gateway REST API stages."
  query       = query.apigateway_rest_api_stage_xray_tracing

  tags = merge(local.conformance_pack_apigateway_common_tags, {
    well_architected = "true"
  })
}

query "apigateway_rest_api_stage_xray_tracing" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when tracing_enabled then 'ok'
        else 'alarm'
      end as status,
      case
        when tracing_enabled then title || ' X-Ray tracing enabled.'
        else title || ' X-Ray tracing disabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_api_gateway_stage;
  EOQ
}
