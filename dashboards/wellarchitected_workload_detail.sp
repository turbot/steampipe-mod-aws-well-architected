dashboard "wellarchitected_workload_detail" {

  title         = "AWS Well-Architected Workload Detail"
  #documentation = file("./dashboards/ec2/docs/ec2_instance_detail.md")

  tags = merge(local.wellarchitected_common_tags, {
    type = "Dashboard"
  })

  input "workload_arn" {
    title = "Select a workload:"
    query = query.wellarchitected_workload_input
    width = 4
  }

  container {

    card {
      width = 2
      query = query.wellarchitected_workload_answered_question_count
      args  = [self.input.workload_arn.value]
    }

    card {
      width = 2
      query = query.wellarchitected_workload_high_risks_count
      args  = [self.input.workload_arn.value]
    }

    card {
      width = 2
      query = query.wellarchitected_workload_medium_risks_count
      args  = [self.input.workload_arn.value]
    }

    card {
      width = 2
      query = query.wellarchitected_workload_none_risks_count
      args  = [self.input.workload_arn.value]
    }

    card {
      width = 2
      query = query.wellarchitected_workload_not_applicable_risks_count
      args  = [self.input.workload_arn.value]
    }

  }

  container {

    chart {
      type  = "column"
      title = "Risk Counts by Lens"
      grouping = "compare"
      width = 4

      series high_risks {
        title = "High Risks"
        color = "red"
      }

      series medium_risks {
        title = "Medium Risks"
        color = "yellow"
      }

      series none_risks {
        title = "No Improvements"
        color = "green"
      }

      series not_applicable_risks {
        title = "N/A"
        color = "gray"
      }

      series unanswered_risks {
        title = "Unanswered"
        color = "gray"
      }

      axes {
        x {
          //title {
          //  value  = "Lens"
          //}
          labels {
            display = "always"
          }
        }
      }

      query = query.wellarchitected_workload_lens_risk_counts
      args = [self.input.workload_arn.value]
    }

    chart {
      type  = "column"
      title = "Risk Counts by Pillars"
      grouping = "compare"
      width = 4

      series high_risks {
        title = "High Risks"
        color = "red"
      }

      series medium_risks {
        title = "Medium Risks"
        color = "yellow"
      }

      series none_risks {
        title = "No Improvements"
        color = "green"
      }

      series not_applicable_risks {
        title = "N/A"
        color = "gray"
      }

      series unanswered_risks {
        title = "Unanswered"
        color = "gray"
      }

      axes {
        x {
          //title {
          //  value  = "Pillar"
          //}
          labels {
            display = "always"
          }
        }
      }

      query = query.wellarchitected_workload_pillar_risk_counts
      args = [self.input.workload_arn.value]
    }

  }

}

# Input queries

query "wellarchitected_workload_input" {
  sql = <<-EOQ
    select
      title as label,
      workload_arn as value,
      json_build_object(
        'account_id', account_id,
        'region', region,
        'workload_name', workload_name
      ) as tags
    from
      aws_wellarchitected_workload
    order by
      title;
  EOQ
}

query "wellarchitected_workload_high_risks_count" {
  sql = <<-EOQ
    select
      'High Risks' as label,
      coalesce((risk_counts ->> 'HIGH')::int, 0) as value,
      case
        coalesce((risk_counts ->> 'HIGH')::int, 0) when 0 then 'ok'
        else 'alert'
      end as type
    from
      aws_wellarchitected_workload
    where
      workload_arn = $1;
  EOQ
}

query "wellarchitected_workload_medium_risks_count" {
  sql = <<-EOQ
    select
      'Medium Risks' as label,
      coalesce((risk_counts ->> 'MEDIUM')::int, 0) as value,
      case
        coalesce((risk_counts ->> 'MEDIUM')::int, 0) when 0 then 'ok'
        else 'alert'
      end as type
    from
      aws_wellarchitected_workload
    where
      workload_arn = $1;
  EOQ
}

query "wellarchitected_workload_none_risks_count" {
  sql = <<-EOQ
    select
      'No Improvements' as label,
      coalesce((risk_counts ->> 'NONE')::int, 0) as value
    from
      aws_wellarchitected_workload
    where
      workload_arn = $1;
  EOQ
}

query "wellarchitected_workload_not_applicable_risks_count" {
  sql = <<-EOQ
    select
      'N/A' as label,
      coalesce((risk_counts ->> 'NOT_APPLICABLE')::int, 0) as value
    from
      aws_wellarchitected_workload
    where
      workload_arn = $1;
  EOQ
}

query "wellarchitected_workload_answered_question_count" {
  sql = <<-EOQ
    with question_counts as (
      select
        coalesce((risk_counts ->> 'UNANSWERED')::int, 0) as unanswered_questions,
        coalesce((risk_counts ->> 'HIGH')::int, 0) + coalesce((risk_counts ->> 'MEDIUM')::int, 0) + coalesce((risk_counts ->> 'NONE')::int, 0) + coalesce((risk_counts ->> 'NOT_APPLICABLE')::int, 0) as answered_questions
      from
        aws_wellarchitected_workload
      where
        workload_arn = $1
    )
    select
      'Answered Questions' as label,
      answered_questions || '/' || unanswered_questions + answered_questions || ' (' || ((unanswered_questions + answered_questions)/answered_questions)::numeric || '%)' as value,
      case
        when unanswered_questions = 0 then 'ok'
        else 'alert'
      end as type
    from
      question_counts
  EOQ
}

query "wellarchitected_workload_lens_risk_counts" {
  sql = <<-EOQ
    with workload_info as (
      select
        workload_id
      from
        aws_wellarchitected_workload
      where
        workload_arn = $1
    )
    select
      r.lens_name,
      (r.risk_counts ->> 'HIGH')::int as high_risks,
      (r.risk_counts ->> 'MEDIUM')::int as medium_risks,
      (r.risk_counts ->> 'NONE')::int as none_risks,
      (r.risk_counts ->> 'NOT_APPLICABLE')::int as not_applicable_risks
      --(r.risk_counts ->> 'UNANSWERED')::int as unanswered_risks
    from
      aws_wellarchitected_lens_review as r,
      workload_info as w
    where
      r.workload_id = w.workload_id
    group by
      r.lens_name,
      r.risk_counts
    order by
      r.lens_name
  EOQ
}

query "wellarchitected_workload_pillar_risk_counts" {
  sql = <<-EOQ
    with workload_info as (
      select
        workload_id
      from
        aws_wellarchitected_workload
      where
        workload_arn = $1
    )
    select
      p ->> 'PillarName' as pillar_name,
      sum((p -> 'RiskCounts' ->> 'HIGH')::int) as high_risks,
      sum((p -> 'RiskCounts' ->> 'MEDIUM')::int) as medium_risks,
      sum((p -> 'RiskCounts' ->> 'NONE')::int) as none_risks,
      sum((p -> 'RiskCounts' ->> 'NOT_APPLICABLE')::int) as not_applicable_risks
      --sum((p -> 'RiskCounts' ->> 'UNANSWERED')::int) as unanswered_risks
    from
      aws_wellarchitected_lens_review as r,
      jsonb_array_elements(r.pillar_review_summaries) as p,
      workload_info as w
    where
      r.workload_id = w.workload_id
    group by
      pillar_name
    order by
      pillar_name
  EOQ
}

