// Risk types from aws_wellarchitected_workload are not returned if their count is 0, so use coalesce(..., 0)
// But from aws_wellarchitected_lens_review, all risk types are returned even when their count is 0
dashboard "wellarchitected_workload_risks_report" {

  title         = "AWS Well-Architected Workload Risks Report"
  documentation = file("./dashboards/docs/wellarchitected_workload_risks_report.md")

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
          'account_id', account_id,
          'region', region,
          'lens_alias', lens_alias
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

    # Analysis
    card {
      query = query.wellarchitected_workload_count
      width = 2
    }

    # Assessments
    card {
      query = query.wellarchitected_workload_with_high_issue_count
      width = 2
    }

    card {
      query = query.wellarchitected_workload_high_issue_count
      width = 2
    }

    card {
      query = query.wellarchitected_workload_with_medium_issue_count
      width = 2
    }

    card {
      query = query.wellarchitected_workload_medium_issue_count
      width = 2
    }

  }

  container {
    title = "Benchmark Risks"

    card {
      query = query.benchmark_risk_counts
      type  = "alert"
      width = 2
      args = {
        "risk" = "HIGH"
        "label" = "Average High Risks"
        "lens_arn" = self.input.lens_arn.value
      }
    }
    card {
      query = query.benchmark_risk_counts
      type  = "alert"
      width = 2
      args = {
        "risk" = "MEDIUM"
        "label" = "Average Medium Risks"
        "lens_arn" = self.input.lens_arn.value
      }
    }
    card {
      query = query.benchmark_risk_counts
      type  = "ok"
      width = 2
      args = {
        "risk" = "NONE"
        "label" = "Average No Improvements"
        "lens_arn" = self.input.lens_arn.value
      }
    }
  }

  container {
    title = "Benchmark Pillars"

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

    chart {
      title = "Average High Risk by Pillar"
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

    chart {
      title = "Average Medium Risk by Pillar"
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

  container {

    table {
      width = 12
      title = "Risk Counts"
      query = query.wellarchitected_workload_risk_count_table
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

# Card Queries

query "wellarchitected_workload_count" {
  sql = <<-EOQ
    select
      count(*) as "Workloads"
    from
      aws_wellarchitected_workload;
  EOQ
}

query "wellarchitected_workload_with_high_issue_count" {
  sql = <<-EOQ
    with workloads_with_high_issues as (
      select
        workload_id
      from
        aws_wellarchitected_workload
      where
        coalesce((risk_counts ->> 'HIGH')::int, 0) > 0
    )
    select
      count(*) as value,
      'Workloads with High Risks' as label,
      case
        count(*) when 0 then 'ok'
        else 'alert'
      end as type
    from
      workloads_with_high_issues;
  EOQ
}

query "wellarchitected_workload_high_issue_count" {
  sql = <<-EOQ
    with workloads_high_issue_count as (
      select
        coalesce((risk_counts ->> 'HIGH')::int, 0) as risk_count_high
      from
        aws_wellarchitected_workload
    )
    select
      sum(risk_count_high) as value,
      'Total High Risks' as label,
      case
        sum(risk_count_high) when 0 then 'ok'
        else 'alert'
      end as type
    from
      workloads_high_issue_count;
  EOQ
}

query "wellarchitected_workload_with_medium_issue_count" {
  sql = <<-EOQ
    with workloads_with_medium_issues as (
      select
        workload_id
      from
        aws_wellarchitected_workload
      where
      coalesce((risk_counts ->> 'MEDIUM')::int, 0) > 0
    )
    select
      count(*) as value,
      'Workloads with Medium Risks' as label,
      case
        count(*) when 0 then 'ok'
        else 'alert'
      end as type
    from
      workloads_with_medium_issues;
  EOQ
}

query "wellarchitected_workload_medium_issue_count" {
  sql = <<-EOQ
    with workloads_medium_issue_count as (
      select
        coalesce((risk_counts ->> 'MEDIUM')::int, 0) as risk_count_medium
      from
        aws_wellarchitected_workload
    )
    select
      sum(risk_count_medium) as value,
      'Total Medium Risks' as label,
      case
        sum(risk_count_medium) when 0 then 'ok'
        else 'alert'
      end as type
    from
      workloads_medium_issue_count;
  EOQ
}

query "wellarchitected_workload_high_medium_risk_counts" {
  sql = <<-EOQ
    -- Get current risk counts
    select
      workload_id,
      workload_name,
      coalesce((workload -> 'RiskCounts' ->> 'HIGH')::int, 0) as high_risks,
      coalesce((workload -> 'RiskCounts' ->> 'MEDIUM')::int, 0) as medium_risks
    from
      aws_wellarchitected_workload
    group by
      workload_name,

  EOQ
}

query "wellarchitected_workload_milestone_risk_counts" {
  sql = <<-EOQ
    -- Get current risk counts
    select
      workload_id,
      workload_name,
      'latest' as milestone_name,
      101 as milestone_number, -- 100 milestone max for workloads
      updated_at as recorded_at,
      risk_counts
    from
      aws_wellarchitected_workload
    union
    -- Get past milestone risk counts
    select
      workload_id,
      workload ->> 'WorkloadName' as workload_name,
      milestone_name,
      milestone_number,
      recorded_at,
      workload -> 'RiskCounts' as risk_counts
    from
      aws_wellarchitected_milestone
    order by
      workload_id,
      milestone_number
  EOQ
}

query "wellarchitected_workload_milestone_lens_review_risk_counts" {
  sql = <<-EOQ
    -- Get current version's lens review
    select
      r.workload_id,
      r.milestone_number,
      r.lens_arn,
      jsonb_pretty(r.risk_counts) as lens_risk_counts,
      p ->> 'PillarId' as pillar_id,
      p ->> 'PillarName' as pillar_name,
      p -> 'RiskCounts' as pillar_risk_counts
    from
      aws_wellarchitected_lens_review as r,
      jsonb_array_elements(pillar_review_summaries) as p
    union
    -- Get past milestone lens reviews
    select
      r.workload_id,
      r.milestone_number,
      r.lens_arn,
      jsonb_pretty(r.risk_counts) as lens_risk_counts,
      p ->> 'PillarId' as pillar_id,
      p ->> 'PillarName' as pillar_name,
      p -> 'RiskCounts' as pillar_risk_counts
    from
      aws_wellarchitected_milestone as m
      left join
        aws_wellarchitected_lens_review as r
        on m.milestone_number = r.milestone_number,
        jsonb_array_elements(pillar_review_summaries) as p
  EOQ
}

query "wellarchitected_workload_risk_count_table" {
  sql = <<-EOQ
    select
      workload_name as "Name",
      coalesce((risk_counts ->> 'HIGH')::int, 0) as "High",
      coalesce((risk_counts ->> 'MEDIUM')::int, 0) as "Medium",
      coalesce((risk_counts ->> 'NONE')::int, 0) as "No Improvements",
      coalesce((risk_counts ->> 'NOT_APPLICABLE')::int, 0) as "N/A",
      coalesce((risk_counts ->> 'UNANSWERED')::int, 0) as "Unanswered"
  from
    aws_wellarchitected_workload
  order by
    "High" desc,
    "Medium" desc
  EOQ
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
