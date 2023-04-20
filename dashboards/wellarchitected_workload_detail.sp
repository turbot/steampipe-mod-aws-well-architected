dashboard "wellarchitected_workload_detail" {

  title = "AWS Well-Architected Workload Detail"
  #documentation = file("./dashboards/ec2/docs/ec2_instance_detail.md")

  tags = merge(local.wellarchitected_common_tags, {
    type = "Dashboard"
  })

  input "workload_id" {
    title = "Select a workload:"
    query = query.wellarchitected_workload_input
    width = 4
  }

  input "lens_arn" {
    title = "Select a lens:"
    type  = "multicombo"
    width = 3

    query = query.wellarchitected_lens_input
    args  = [self.input.workload_id.value]
  }

  container {

    card {
      width = 2
      query = query.wellarchitected_workload_answered_question_count
      args  = [self.input.workload_id.value]
    }

    card {
      width = 2
      query = query.wellarchitected_workload_high_risks_count
      args  = [self.input.workload_id.value]
    }

    card {
      width = 2
      query = query.wellarchitected_workload_medium_risks_count
      args  = [self.input.workload_id.value]
    }

    card {
      width = 2
      query = query.wellarchitected_workload_none_risks_count
      args  = [self.input.workload_id.value]
    }

    card {
      width = 2
      query = query.wellarchitected_workload_not_applicable_risks_count
      args  = [self.input.workload_id.value]
    }

  }

  container {

    chart {
      type     = "column"
      title    = "Risk Counts by Lens"
      grouping = "compare"
      width    = 4

      series "high_risks" {
        title = "High Risks"
        color = "red"
      }

      series "medium_risks" {
        title = "Medium Risks"
        color = "yellow"
      }

      series "none_risks" {
        title = "No Improvements"
        color = "green"
      }

      series "not_applicable_risks" {
        title = "N/A"
        color = "gray"
      }

      series "unanswered_risks" {
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
      args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
      }
    }

    chart {
      type     = "column"
      title    = "Risk Counts by Pillars"
      grouping = "compare"
      width    = 4

      series "high_risks" {
        title = "High Risks"
        color = "red"
      }

      series "medium_risks" {
        title = "Medium Risks"
        color = "yellow"
      }

      series "none_risks" {
        title = "No Improvements"
        color = "green"
      }

      series "not_applicable_risks" {
        title = "N/A"
        color = "gray"
      }

      series "unanswered_risks" {
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
      args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
      }
    }

    chart {
      // type     = "area"
      // grouping = "stack"
      type     = "line"
      title    = "Risk Counts by Milestone"
      grouping = "compare"
      width    = 4

      series "high_risks" {
        title = "High Risks"
        color = "red"
      }

      series "medium_risks" {
        title = "Medium Risks"
        color = "yellow"
      }

      series "none_risks" {
        title = "No Improvements"
        color = "green"
      }

      series "not_applicable_risks" {
        title = "N/A"
        color = "gray"
      }

      series "unanswered_risks" {
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

      query = query.wellarchitected_workload_milestones_risk_counts
      args = {
        workload_id = self.input.workload_id.value
        // lens_arn     = self.input.lens_arn.value
      }
    }

  }

  container {
    container {

      table {
        title = "Risk Counts by lens"
        width = 6
        query = query.workload_lens_risk_counts
        args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
      }
      }

      table {
        title = "Risk Counts by pillar"
        width = 6
        query = query.workload_pillar_risk_counts
        args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
      }
      }

    }
  }

}

# Input queries

query "wellarchitected_workload_input" {
  sql = <<-EOQ
    select
      title as label,
      workload_id as value,
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

query "wellarchitected_lens_input" {
  sql = <<-EOQ
    select
      l.title as label,
      l.arn as value,
      json_build_object(
        'account_id', l.account_id,
        'region', l.region,
        'lens_alias', l.lens_alias
      ) as tags
    from
      aws_wellarchitected_workload w,
      aws_wellarchitected_lens l,
      jsonb_array_elements_text(w.lenses) la
    where
      (la = l.lens_alias or la = l.arn)
      and l.region = w.region
      and w.workload_id = $1
    order by
      l.title;
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
      workload_id = $1;
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
      workload_id = $1;
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
      workload_id = $1;
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
      workload_id = $1;
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
        workload_id = $1
    )
    select
      'Answered Questions' as label,
      answered_questions || '/' || unanswered_questions + answered_questions || ' (' || (100 * answered_questions/(unanswered_questions + answered_questions))::numeric || '%)' as value,
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
    select
      r.lens_name,
      (r.risk_counts ->> 'HIGH')::int as high_risks,
      (r.risk_counts ->> 'MEDIUM')::int as medium_risks,
      (r.risk_counts ->> 'NONE')::int as none_risks,
      (r.risk_counts ->> 'NOT_APPLICABLE')::int as not_applicable_risks
      --(r.risk_counts ->> 'UNANSWERED')::int as unanswered_risks
    from
      aws_wellarchitected_lens_review as r
    where
      r.workload_id = $1
      and r.lens_arn = any(string_to_array($2, ','))
    group by
      r.lens_name,
      r.risk_counts
    order by
      r.lens_name
  EOQ

  param "workload_id" {}
  param "lens_arn" {}
}

query "workload_lens_risk_counts" {
  sql = <<-EOQ
    select
      r.lens_name as "Lens Name",
      (r.risk_counts ->> 'HIGH')::int as "High Risks",
      (r.risk_counts ->> 'MEDIUM')::int as "Medium Risks",
      (r.risk_counts ->> 'NONE')::int as "None Risks",
      (r.risk_counts ->> 'NOT_APPLICABLE')::int as "Not Applicable Risks"
      --(r.risk_counts ->> 'UNANSWERED')::int as unanswered_risks
    from
      aws_wellarchitected_lens_review as r
    where
      r.workload_id = $1
      and r.lens_arn = any(string_to_array($2, ','))
    group by
      r.lens_name,
      r.risk_counts
    order by
      r.lens_name
  EOQ

  param "workload_id" {}
  param "lens_arn" {}
}

query "wellarchitected_workload_pillar_risk_counts" {
  sql = <<-EOQ
    select
      p ->> 'PillarName' as pillar_name,
      sum((p -> 'RiskCounts' ->> 'HIGH')::int) as high_risks,
      sum((p -> 'RiskCounts' ->> 'MEDIUM')::int) as medium_risks,
      sum((p -> 'RiskCounts' ->> 'NONE')::int) as none_risks,
      sum((p -> 'RiskCounts' ->> 'NOT_APPLICABLE')::int) as not_applicable_risks
      --sum((p -> 'RiskCounts' ->> 'UNANSWERED')::int) as unanswered_risks
    from
      aws_wellarchitected_lens_review as r,
      jsonb_array_elements(r.pillar_review_summaries) as p
    where
      r.workload_id = $1
      and r.lens_arn = any(string_to_array($2, ','))
    group by
      pillar_name
    order by
      pillar_name
  EOQ

  param "workload_id" {}
  param "lens_arn" {}
}

query "workload_pillar_risk_counts" {
  sql = <<-EOQ
    select
      p ->> 'PillarName' as "Pillar Name",
      sum((p -> 'RiskCounts' ->> 'HIGH')::int) as "High Risks",
      sum((p -> 'RiskCounts' ->> 'MEDIUM')::int) as "Medium Risks",
      sum((p -> 'RiskCounts' ->> 'NONE')::int) as "None Risks",
      sum((p -> 'RiskCounts' ->> 'NOT_APPLICABLE')::int) as "Not Applicable Risks"
      --sum((p -> 'RiskCounts' ->> 'UNANSWERED')::int) as unanswered_risks
    from
      aws_wellarchitected_lens_review as r,
      jsonb_array_elements(r.pillar_review_summaries) as p
    where
      r.workload_id = $1
      and r.lens_arn = any(string_to_array($2, ','))
    group by
      "Pillar Name"
    order by
      "Pillar Name"
  EOQ

  param "workload_id" {}
  param "lens_arn" {}
}

// query "wellarchitected_workload_milestones_risk_counts" {
//   sql = <<-EOQ
//     with workload_info as (
//   select
//     workload_id
//   from
//     aws_wellarchitected_workload
//   where
//     workload_arn = $1
// )
// select
//   m.milestone_name,
//   (m.workload -> 'RiskCounts' ->> 'HIGH') :: int as high_risks,
//   (m.workload -> 'RiskCounts' ->> 'MEDIUM') :: int as medium_risks,
//   (m.workload -> 'RiskCounts' ->> 'NONE') :: int as none_risks,
//   (m.workload -> 'RiskCounts' ->> 'NOT_APPLICABLE') :: int as not_applicable_risks,
//   (m.workload -> 'RiskCounts' ->> 'UNANSWERED') :: int as unanswered_risks
// from
//   workload_info as w,
//   aws_wellarchitected_milestone as m
// where
//   w.workload_id = m.workload_id
// order by
//   recorded_at
//   EOQ

//   param "workload_arn" {}
// param "lens_arn" {}
// }

// query "wellarchitected_workload_milestones_risk_counts" {
//   sql = <<-EOQ
//     with milestone_info as (
//       select
//         workload_id,
//         milestone_number,
//         milestone_name,
//         workload ->> 'WorkloadArn' as workload_arn
//       from
//         aws_wellarchitected_milestone
//       where
//         workload ->> 'WorkloadArn' = 'arn:aws:wellarchitected:us-east-1:533793682495:workload/f9eec851ac1d8d9d5b9938615da016ce'
//     ), lens_review as (
//       select
//         *
//       from
//         aws_wellarchitected_lens_review
//       where
//         milestone_number in (select milestone_number from aws_wellarchitected_milestone where workload ->> 'WorkloadArn' = 'arn:aws:wellarchitected:us-east-1:533793682495:workload/f9eec851ac1d8d9d5b9938615da016ce')
//     ) select
//       m.milestone_number,
//       (risk_counts ->> 'HIGH')::int as high_risks,
//       (risk_counts ->> 'MEDIUM')::int as medium_risks,
//       (risk_counts ->> 'NONE')::int as none_risks,
//       (risk_counts ->> 'NOT_APPLICABLE')::int as not_applicable_risks,
//       (risk_counts ->> 'UNANSWERED')::int as unanswered_risks
//     from
//       lens_review as r
//       join milestone_info as m
//         on r.workload_id = m.workload_id
//         --and r.milestone_number = m.milestone_number
//     order by
//       r.milestone_number
//   EOQ

//   param "workload_arn" {}
//   // param "lens_arn" {}
// }

query "wellarchitected_workload_milestones_risk_counts" {
  sql = <<-EOQ
    with milestone_info as (
      select
        workload_id,
        milestone_number,
        milestone_name
      from
        aws_wellarchitected_milestone
      where
        workload_id = $1
    ), lens_review as (
      select
        *
      from
        aws_wellarchitected_lens_review
      where
        milestone_number in (select milestone_number from aws_wellarchitected_milestone where workload_id = 'f9eec851ac1d8d9d5b9938615da016ce')

      union

      select
        *
      from
        aws_wellarchitected_lens_review
    ) select
      milestone_number,
      (risk_counts ->> 'HIGH')::int as high_risks,
      (risk_counts ->> 'MEDIUM')::int as medium_risks,
      (risk_counts ->> 'NONE')::int as none_risks,
      (risk_counts ->> 'NOT_APPLICABLE')::int as not_applicable_risks
      --(risk_counts ->> 'UNANSWERED')::int as unanswered_risks
    from
      lens_review as r
    where
      workload_id = (select workload_id from aws_wellarchitected_workload where workload_id = 'f9eec851ac1d8d9d5b9938615da016ce')
    order by
      r.milestone_number
  EOQ

  param "workload_id" {}
  // param "lens_arn" {}
}
