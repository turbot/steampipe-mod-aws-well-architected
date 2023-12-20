dashboard "wellarchitected_benchmark_risks_report" {

  title = "AWS Well-Architected Benchmark Risks Report"

  documentation = file("./dashboards/docs/wellarchitected_benchmark_risks_report.md")

  tags = merge(local.wellarchitected_common_tags, {
    type = "Report"
  })

  input "lens_arn" {
    title = "Select a lens:"
    type  = "multicombo"
    width = 3

    sql = <<-EOQ
      select
        title as label,
        arn as value,
        json_build_object(
          'account_id', l.account_id,
          'region', l.region,
          'lens_alias', l.lens_alias
        ) as tags
      from
        aws_wellarchitected_lens
      order by
        case
          arn when 'arn:aws:wellarchitected::aws:lens/wellarchitected' then 0
          else 1
        end,
        arn
    EOQ
  }

  container {
    card {
      query = query.benchmark_risk_counts
      type  = "alert"
      width = 2
      args = {
        "risk" = "HIGH"
        "label" = "High Risks"
        "lens_arn" = self.input.lens_arn.value
      }
    }
    card {
      query = query.benchmark_risk_counts
      type  = "alert"
      width = 2
      args = {
        "risk" = "MEDIUM"
        "label" = "Medium Risks"
        "lens_arn" = self.input.lens_arn.value
      }
    }
    card {
      query = query.benchmark_risk_counts
      type  = "ok"
      width = 2
      args = {
        "risk" = "NONE"
        "label" = "Resolved"
        "lens_arn" = self.input.lens_arn.value
      }
    }
  }

  container {
    title = "Benchmark de Pilares"

    chart {
      base = chart.risk_by_pillar
      title = "Cost Optimization"
      args = {
        "pillar" = "costOptimization"
        "lens_arn" = self.input.lens_arn.value
      }
      width = 2
    }

    chart {
      base = chart.risk_by_pillar
      title = "Operational Excellence"
      args = {
        "pillar" = "operationalExcellence"
        "lens_arn" = self.input.lens_arn.value
      }
      width = 2
    }

    chart {
      base = chart.risk_by_pillar
      title = "Performance Efficiency"
      args = {
        "pillar" = "performance"
        "lens_arn" = self.input.lens_arn.value
      }
      width = 2
    }

    chart {
      base = chart.risk_by_pillar
      title = "Reliability"
      args = {
        "pillar" = "reliability"
        "lens_arn" = self.input.lens_arn.value
      }
      width = 2
    }

    chart {
      base = chart.risk_by_pillar
      title = "Security"
      args = {
        "pillar" = "security"
        "lens_arn" = self.input.lens_arn.value
      }
      width = 2
    }

    chart {
      base = chart.risk_by_pillar
      title = "Sustainability"
      args = {
        "pillar" = "sustainability"
        "lens_arn" = self.input.lens_arn.value
      }
      width = 2
    }

  }

  container {
    title = "Benchmark de High Risk"

    chart {
      title = "High Risk por Pilar"
      type = "column"
      query = query.benchmark_risk
      series "HIGH" {
        title = "High"
        color = "alert"
      }
      args = {
        "risk" = "HIGH"
        "lens_arn" = self.input.lens_arn.value
      }
      width = 12
    }

  }

  container {
    title = "Benchmark de Medium Risk"

    chart {
      title = "Medium Risk por Pilar"
      type = "column"
      query = query.benchmark_risk
      series "MEDIUM" {
        title = "Medium"
        color = "#FF9900"
      }
      args = {
        "risk" = "MEDIUM"
        "lens_arn" = self.input.lens_arn.value
      }
      width = 12
    }

  }
}

chart "risk_by_pillar" {
    type = "donut"

    series "value" {
        point "HIGH" {
            color = "alert"
        }
        point "MEDIUM" {
            color = "#FF9900"
        }
        point "NONE" {
            color = "ok"
        }
        point "UNANSWERED" {
            color = "gray"
        }
    }

    legend {
        display = "all"
        position = "bottom"
    }
    
    query = query.media_total_risk
    width = 2
}

query "media_total_risk" {
  sql = <<-EOT
    select
      'HIGH' as risk,
      ROUND(AVG((s -> 'RiskCounts' ->> 'HIGH')::int)) as value
    from
      aws_wellarchitected_lens_review
    join JSONB_ARRAY_ELEMENTS(pillar_review_summaries) as s on
      true
    where
      s ->> 'PillarId' = $1
      and lens_arn = any(string_to_array($2,
      ','))
   
    union all

    select
      'MEDIUM' as risk,
      ROUND(AVG((s -> 'RiskCounts' ->> 'MEDIUM')::int)) as value
    from
      aws_wellarchitected_lens_review
    join JSONB_ARRAY_ELEMENTS(pillar_review_summaries) as s on
      true
    where
      s ->> 'PillarId' = $1
      and lens_arn = any(string_to_array($2,
      ','))
    
    union all

    select
      'NONE' as risk,
      ROUND(AVG((s -> 'RiskCounts' ->> 'NONE')::int)) as value
    from
      aws_wellarchitected_lens_review
    join JSONB_ARRAY_ELEMENTS(pillar_review_summaries) as s on
      true
    where
      s ->> 'PillarId' = $1
      and lens_arn = any(string_to_array($2,
      ','))
  EOT
  param "pillar" {}
  param "lens_arn" {}
}

query "benchmark_risk_counts" {
  sql = <<-EOQ
    select
      $1 as label,
      round(avg((risk_counts -> $2) :: int)) as value
    from
      aws_wellarchitected_lens_review
    where
      lens_arn = any(string_to_array($3,
      ','))
  EOQ
  param "label" {}
  param "risk" {}
  param "lens_arn" {}
}

query "benchmark_risk" {
  sql = <<-EOT
    select
      s ->> 'PillarName' as pillar_name,
      $1 as risk,
      round(avg((s -> 'RiskCounts' ->> $1) :: int)) as value
    from
      aws_wellarchitected_lens_review,
      jsonb_array_elements(pillar_review_summaries) as s
    where
      lens_arn = any(string_to_array($2,
      ','))
    group by 
      s ->> 'PillarName'
  EOT
  param "risk" {}
  param "lens_arn" {}
}