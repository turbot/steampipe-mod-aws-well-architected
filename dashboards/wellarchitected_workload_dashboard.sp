locals {
  wellarchitected_common_tags = {
    service = "AWS/WellArchitected"
  }
}

dashboard "wellarchitected_workload_dashboard" {

  title         = "AWS Well-Architected Workload Dashboard"
  #documentation = file("./dashboards/wellarchitected/docs/wellarchitected_workload_dashboard.md")

  tags = merge(local.wellarchitected_common_tags, {
    type = "Dashboard"
  })

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


    /*
    card {
      query = query.wellarchitected_public_workload_count
      width = 2
      href  = dashboard.wellarchitected_workload_public_access_report.url_path
    }

    card {
      query = query.wellarchitected_ebs_optimized_count
      width = 2
    }

    # Costs
    card {
      type  = "info"
      icon  = "currency-dollar"
      query = query.wellarchitected_workload_cost_mtd
      width = 2
    }
    */
  }

  /*
  container {

    title = "Assessments"
    width = 6

    chart {
      title = "Risks"
      query = query.wellarchitected_workload_risk_counts
      type  = "donut"
      width = 4

      series "count" {
        point "private" {
          color = "ok"
        }
        point "public" {
          color = "alert"
        }
      }
    }

    chart {
      title = "EBS Optimized Status"
      query = query.wellarchitected_workload_ebs_optimized_status
      type  = "donut"
      width = 4

      series "count" {
        point "enabled" {
          color = "ok"
        }
        point "disabled" {
          color = "alert"
        }
      }
    }

    chart {
      title = "Detailed Monitoring Status"
      query = query.wellarchitected_workload_detailed_monitoring_enabled
      type  = "donut"
      width = 4

      series "count" {
        point "enabled" {
          color = "ok"
        }
        point "disabled" {
          color = "alert"
        }
      }
    }
  }
  */

  /*
  container {

    title = "Costs"
    width = 6


    table {
      width = 6
      title = "Forecast"
      query = query.wellarchitected_monthly_forecast_table
    }

    chart {
      width = 6
      title = "Well-Architected Compute Monthly Unblended Cost"
      type  = "column"
      query = query.wellarchitected_workload_cost_per_month
    }

  }

  container {

    title = "Analysis"

    chart {
      title = "Workloads by Account"
      query = query.wellarchitected_workload_by_account
      type  = "column"
      width = 4
    }

    chart {
      title = "Workloads by Region"
      query = query.wellarchitected_workload_by_region
      type  = "column"
      width = 4
    }

    chart {
      title = "Workloads by State"
      query = query.wellarchitected_workload_by_state
      type  = "column"
      width = 4
    }

    chart {
      title = "Workloads by Age"
      query = query.wellarchitected_workload_by_creation_month
      type  = "column"
      width = 4
    }

    chart {
      title = "Workloads by Type"
      query = query.wellarchitected_workload_by_type
      type  = "column"
      width = 4
    }

  }

  container {

    title = "Performance & Utilization"

    chart {
      title = "Top 10 CPU - Last 7 days"
      query = query.wellarchitected_top10_cpu_past_week
      type  = "line"
      width = 6
    }

    chart {
      title = "Average Max Daily CPU - Last 30 days"
      query = query.wellarchitected_workload_by_cpu_utilization_category
      type  = "column"
      width = 6
    }

  }
  */
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
      (risk_counts ->> 'HIGH')::int > 0
    )
    select
      count(*) as value,
      'Workloads with High Risk Issues' as label,
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
        (risk_counts ->> 'HIGH')::int as risk_count_high
      from
        aws_wellarchitected_workload
    )
    select
      sum(risk_count_high) as value,
      'Total High Risk Issues' as label,
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
      (risk_counts ->> 'MEDIUM')::int > 0
    )
    select
      count(*) as value,
      'Workloads with Medium Risk Issues' as label,
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
        (risk_counts ->> 'MEDIUM')::int as risk_count_medium
      from
        aws_wellarchitected_workload
    )
    select
      sum(risk_count_medium) as value,
      'Total Medium Risk Issues' as label,
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
      (workload -> 'RiskCounts' ->> 'HIGH')::int as high_risks,
      (workload -> 'RiskCounts' ->> 'MEDIUM')::int as medium_risks
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


/*
query "wellarchitected_public_workload_count" {
  sql = <<-EOQ
    select
      count(*) as value,
      'Publicly Accessible' as label,
      case count(*) when 0 then 'ok' else 'alert' end as "type"
    from
      aws_wellarchitected_workload
    where
      public_ip_address is not null
  EOQ
}

query "wellarchitected_ebs_optimized_count" {
  sql = <<-EOQ
    select
      count(*) as value,
      'EBS Not Optimized' as label,
      case count(*) when 0 then 'ok' else 'alert' end as "type"
    from
      aws_wellarchitected_workload
    where
      not ebs_optimized
  EOQ
}

query "wellarchitected_workload_cost_mtd" {
  sql = <<-EOQ
    select
      'Cost - MTD' as label,
      sum(unblended_cost_amount)::numeric::money as value
    from
      aws_cost_by_service_monthly
    where
      service = 'Amazon Elastic Compute Cloud - Compute'
      and period_end > date_trunc('month', CURRENT_DATE::timestamp)
  EOQ
}

# Assessment Queries

query "wellarchitected_workload_by_public_ip" {
  sql = <<-EOQ
    with workloads as (
      select
        case
          when public_ip_address is null then 'private'
          else 'public'
        end as visibility
      from
        aws_wellarchitected_workload
    )
    select
      visibility,
      count(*)
    from
      workloads
    group by
      visibility
  EOQ
}

query "wellarchitected_workload_ebs_optimized_status" {
  sql = <<-EOQ
    with workloads as (
      select
        case
          when ebs_optimized then 'enabled'
          else 'disabled'
        end as visibility
      from
        aws_wellarchitected_workload
    )
    select
      visibility,
      count(*)
    from
      workloads
    group by
      visibility
  EOQ
}

query "wellarchitected_workload_detailed_monitoring_enabled" {
  sql = <<-EOQ
    with workloads as (
      select
        case
          when monitoring_state = 'enabled' then 'enabled'
          else 'disabled'
        end as visibility
      from
        aws_wellarchitected_workload
    )
    select
      visibility,
      count(*)
    from
      workloads
    group by
      visibility
  EOQ
}

# Cost Queries

query "wellarchitected_monthly_forecast_table" {
  sql = <<-EOQ
    with monthly_costs as (
      select
        period_start,
        period_end,
        case
          when date_trunc('month', period_start) = date_trunc('month', CURRENT_DATE::timestamp) then 'Month to Date'
          when date_trunc('month', period_start) = date_trunc('month', CURRENT_DATE::timestamp - interval '1 month') then 'Previous Month'
          else to_char (period_start, 'Month')
        end as period_label,
        period_end::date - period_start::date as days,
        sum(unblended_cost_amount)::numeric::money as unblended_cost_amount,
        (sum(unblended_cost_amount) / (period_end::date - period_start::date ) )::numeric::money as average_daily_cost,
        date_part('days', date_trunc ('month', period_start) + '1 MONTH'::interval  - '1 DAY'::interval ) as days_in_month,
        sum(unblended_cost_amount) / (period_end::date - period_start::date ) * date_part('days', date_trunc ('month', period_start) + '1 MONTH'::interval  - '1 DAY'::interval )::numeric::money  as forecast_amount
      from
        aws_cost_by_service_monthly as c

      where
        service = 'Amazon Elastic Compute Cloud - Compute'
        and date_trunc('month', period_start) >= date_trunc('month', CURRENT_DATE::timestamp - interval '1 month')

        group by
        period_start,
        period_end
    )

    select
      period_label as "Period",
      unblended_cost_amount as "Cost",
      average_daily_cost as "Daily Avg Cost"
    from
      monthly_costs

    union all
    select
      'This Month (Forecast)' as "Period",
      (select forecast_amount from monthly_costs where period_label = 'Month to Date') as "Cost",
      (select average_daily_cost from monthly_costs where period_label = 'Month to Date') as "Daily Avg Cost"

  EOQ
}

query "wellarchitected_workload_cost_per_month" {
  sql = <<-EOQ
    select
      to_char(period_start, 'Mon-YY') as "Month",
      sum(unblended_cost_amount)::numeric as "Unblended Cost"
    from
      aws_cost_by_service_usage_type_monthly
    where
      service = 'Amazon Elastic Compute Cloud - Compute'
    group by
      period_start
    order by
      period_start
  EOQ
}

# Analysis Queries

query "wellarchitected_workload_by_account" {
  sql = <<-EOQ
    select
      a.title as "Account",
      count(i.*) as "total"
    from
      aws_wellarchitected_workload as i,
      aws_account as a
    where
      a.account_id = i.account_id
    group by
      a.title
    order by
      count(i.*) desc;
  EOQ
}

query "wellarchitected_workload_by_region" {
  sql = <<-EOQ
    select
      region,
      count(i.*) as total
    from
      aws_wellarchitected_workload as i
    group by
      region
  EOQ
}

query "wellarchitected_workload_by_state" {
  sql = <<-EOQ
    select
      workload_state,
      count(workload_state)
    from
      aws_wellarchitected_workload
    group by
      workload_state
  EOQ
}

query "wellarchitected_workload_by_creation_month" {
  sql = <<-EOQ
    with workloads as (
      select
        title,
        launch_time,
        to_char(launch_time,
          'YYYY-MM') as creation_month
      from
        aws_wellarchitected_workload
    ),
    months as (
      select
        to_char(d,
          'YYYY-MM') as month
      from
        generate_series(date_trunc('month',
            (
              select
                min(launch_time)
                from workloads)),
            date_trunc('month',
              current_date),
            interval '1 month') as d
    ),
    workloads_by_month as (
      select
        creation_month,
        count(*)
      from
        workloads
      group by
        creation_month
    )
    select
      months.month,
      workloads_by_month.count
    from
      months
      left join workloads_by_month on months.month = workloads_by_month.creation_month
    order by
      months.month;
  EOQ
}

query "wellarchitected_workload_by_type" {
  sql = <<-EOQ
    select workload_type as "Type", count(*) as "workloads" from aws_wellarchitected_workload group by workload_type order by workload_type
  EOQ
}

# Note the CTE uses the dailt table to be efficient when filtering,
# and the hourly table to show granular line chart

# Performance Queries

query "wellarchitected_top10_cpu_past_week" {
  sql = <<-EOQ
    with top_n as (
    select
      workload_id,
      avg(average)
    from
      aws_wellarchitected_workload_metric_cpu_utilization_daily
    where
      timestamp  >= CURRENT_DATE - INTERVAL '7 day'
    group by
      workload_id
    order by
      avg desc
    limit 10
  )
  select
      timestamp,
      workload_id,
      average
    from
      aws_wellarchitected_workload_metric_cpu_utilization_hourly
    where
      timestamp  >= CURRENT_DATE - INTERVAL '7 day'
      and workload_id in (select workload_id from top_n)
    order by
      timestamp;
  EOQ
}

# underused if avg CPU < 10% every day for last month
query "wellarchitected_workload_by_cpu_utilization_category" {
  sql = <<-EOQ
    with cpu_buckets as (
      select
    unnest(array ['Unused (<1%)','Underutilized (1-10%)','Right-sized (10-90%)', 'Overutilized (>90%)' ]) as cpu_bucket
    ),
    max_averages as (
      select
        workload_id,
        case
          when max(average) <= 1 then 'Unused (<1%)'
          when max(average) between 1 and 10 then 'Underutilized (1-10%)'
          when max(average) between 10 and 90 then 'Right-sized (10-90%)'
          when max(average) > 90 then 'Overutilized (>90%)'
        end as cpu_bucket,
        max(average) as max_avg
      from
        aws_wellarchitected_workload_metric_cpu_utilization_daily
      where
        date_part('day', now() - timestamp) <= 30
      group by
        workload_id
    )
    select
      b.cpu_bucket as "CPU Utilization",
      count(a.*)
    from
      cpu_buckets as b
    left join max_averages as a on b.cpu_bucket = a.cpu_bucket
    group by
      b.cpu_bucket;
  EOQ
}
*/
