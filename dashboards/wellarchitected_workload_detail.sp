// Risk types from aws_wellarchitected_workload are not returned if their count is 0, so use coalesce(..., 0)
// But from aws_wellarchitected_lens_review, all risk types are returned even when their count is 0
dashboard "wellarchitected_workload_detail" {

  title = "AWS Well-Architected Workload Detail"
  documentation = file("./dashboards/docs/wellarchitected_workload_detail.md")

  tags = merge(local.wellarchitected_common_tags, {
    type = "Detail"
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
      args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
      }
    }

    card {
      width = 2
      query = query.wellarchitected_workload_high_risk_count
      args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
      }
    }

    card {
      width = 2
      query = query.wellarchitected_workload_medium_risk_count
      args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
      }
    }

    card {
      width = 2
      query = query.wellarchitected_workload_no_improvements_risk_count
      args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
      }
    }

    card {
      width = 2
      query = query.wellarchitected_workload_not_applicable_risk_count
      args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
      }
    }

  }

  container {

    chart {
      title    = "Risk Counts by Milestone"
      type     = "line"
      grouping = "compare"
      width    = 6

      series "high_risks" {
        title = "High"
        color = "red"
      }

      series "medium_risks" {
        title = "Medium"
        color = "yellow"
      }

      series "no_improvements_risks" {
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
          labels {
            display = "always"
          }
        }
      }

      query = query.wellarchitected_workload_risks_by_milestone
      args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
      }
    }

    chart {
      title    = "Risk Counts by Lens"
      type     = "column"
      grouping = "compare"
      width    = 6

      series "high_risks" {
        title = "High"
        color = "red"
      }

      series "medium_risks" {
        title = "Medium"
        color = "yellow"
      }

      series "no_improvements_risks" {
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
          labels {
            display = "always"
          }
        }
      }

      query = query.wellarchitected_workload_risks_by_lens
      args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
      }
    }

    chart {
      title    = "Unanswered Questions by Milestone"
      type     = "line"
      grouping = "compare"
      width    = 6

      series "unanswered_risks" {
        title = "Unanswered"
        color = "gray"
      }

      axes {
        x {
          labels {
            display = "always"
          }
        }
      }

      query = query.wellarchitected_workload_unanswered_by_milestone
      args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
      }
    }

    chart {
      title    = "Risk Counts by Pillar"
      type     = "column"
      grouping = "compare"
      width    = 6

      series "high_risks" {
        title = "High"
        color = "red"
      }

      series "medium_risks" {
        title = "Medium"
        color = "yellow"
      }

      series "no_improvements_risks" {
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
          labels {
            display = "always"
          }
        }
      }

      query = query.wellarchitected_workload_risks_by_pillar
      args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
      }
    }

  }

  container {

    table {
      title = "Risk Counts by Milestone"
      width = 6
      query = query.wellarchitected_workload_milestone_risk_table
      args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
      }
    }

    table {
      title = "Risk Counts by Lens"
      width = 6
      query = query.wellarchitected_workload_lens_risk_table
      args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
      }
    }

    table {
      title = "Unanswered Questions by Milestone"
      width = 6
      query = query.wellarchitected_workload_milestone_unanswered_table
      args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
      }
    }

    table {
      title = "Risk Counts by Pillar"
      width = 6
      query = query.wellarchitected_workload_pillar_risk_table
      args = {
        workload_id = self.input.workload_id.value
        lens_arn    = self.input.lens_arn.value
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
      and l.account_id = w.account_id
      and l.region = w.region
      and w.workload_id = $1
    order by
      l.title;
  EOQ
}

# Card queries

query "wellarchitected_workload_answered_question_count" {
  sql = <<-EOQ
    with question_counts as (
      select
        sum((risk_counts ->> 'UNANSWERED')::int) as unanswered_questions,
        sum((risk_counts ->> 'HIGH')::int) + sum((risk_counts ->> 'MEDIUM')::int) + sum((risk_counts ->> 'NONE')::int) + sum((risk_counts ->> 'NOT_APPLICABLE')::int) as answered_questions
      from
        aws_wellarchitected_lens_review as r
      where
        r.workload_id = $1
        and r.lens_arn = any(string_to_array($2, ','))
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

  param "workload_id" {}
  param "lens_arn" {}
}

query "wellarchitected_workload_high_risk_count" {
  sql = <<-EOQ
    select
      'High Risks' as label,
      sum((risk_counts ->> 'HIGH')::int) as value,
      case
        sum((risk_counts ->> 'HIGH')::int) when 0 then 'ok'
        else 'alert'
      end as type
    from
      aws_wellarchitected_lens_review as r
    where
      r.workload_id = $1
      and r.lens_arn = any(string_to_array($2, ','))
  EOQ

  param "workload_id" {}
  param "lens_arn" {}
}

query "wellarchitected_workload_medium_risk_count" {
  sql = <<-EOQ
    select
      'Medium Risks' as label,
      sum((risk_counts ->> 'MEDIUM')::int) as value,
      case
        sum((risk_counts ->> 'MEDIUM')::int) when 0 then 'ok'
        else 'alert'
      end as type
    from
      aws_wellarchitected_lens_review as r
    where
      r.workload_id = $1
      and r.lens_arn = any(string_to_array($2, ','))
  EOQ

  param "workload_id" {}
  param "lens_arn" {}
}

query "wellarchitected_workload_no_improvements_risk_count" {
  sql = <<-EOQ
    select
      'No Improvements' as label,
      sum((risk_counts ->> 'NONE')::int) as value
    from
      aws_wellarchitected_lens_review as r
    where
      r.workload_id = $1
      and r.lens_arn = any(string_to_array($2, ','))
  EOQ

  param "workload_id" {}
  param "lens_arn" {}
}

query "wellarchitected_workload_not_applicable_risk_count" {
  sql = <<-EOQ
    select
      'Not Applicable' as label,
      sum((risk_counts ->> 'NOT_APPLICABLE')::int) as value
    from
      aws_wellarchitected_lens_review as r
    where
      r.workload_id = $1
      and r.lens_arn = any(string_to_array($2, ','))
  EOQ

  param "workload_id" {}
  param "lens_arn" {}
}

# Chart queries

query "wellarchitected_workload_risks_by_lens" {
  sql = <<-EOQ
    select
      r.lens_name,
      (r.risk_counts ->> 'HIGH')::int as high_risks,
      (r.risk_counts ->> 'MEDIUM')::int as medium_risks,
      (r.risk_counts ->> 'NONE')::int as no_improvements_risks,
      (r.risk_counts ->> 'NOT_APPLICABLE')::int as not_applicable_risks
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

query "wellarchitected_workload_risks_by_pillar" {
  sql = <<-EOQ
    select
      p ->> 'PillarName' as pillar_name,
      sum((p -> 'RiskCounts' ->> 'HIGH')::int) as high_risks,
      sum((p -> 'RiskCounts' ->> 'MEDIUM')::int) as medium_risks,
      sum((p -> 'RiskCounts' ->> 'NONE')::int) as no_improvements_risks,
      sum((p -> 'RiskCounts' ->> 'NOT_APPLICABLE')::int) as not_applicable_risks
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

query "wellarchitected_workload_risks_by_milestone" {
  sql = <<-EOQ
    with milestone_info as (
      select
        workload_id,
        milestone_number,
        milestone_name,
        recorded_at
      from
        aws_wellarchitected_milestone
      where
        workload_id = $1

      union

      select
        $1 as workload_id,
        0 as milestone_number, -- Lens review API returns latest milestone as 0
        'latest' as milestone_name,
        current_timestamp as recorded_at
    ), lens_review as (
      select
        *
      from
        aws_wellarchitected_lens_review
      where
        milestone_number in (select milestone_number from aws_wellarchitected_milestone where workload_id = $1 union select 0 as milestone_number) -- Latest milestone is returned as 0
        and workload_id = (select workload_id from aws_wellarchitected_workload where workload_id = $1)
    ), risk_data as (
      select
        milestone_number,
        sum((risk_counts ->> 'HIGH')::int) as high_risks,
        sum((risk_counts ->> 'MEDIUM')::int) as medium_risks,
        sum((risk_counts ->> 'NONE')::int) as no_improvements_risks,
        sum((risk_counts ->> 'NOT_APPLICABLE')::int) as not_applicable_risks
        --sum((risk_counts ->> 'UNANSWERED')::int) as unanswered_risks
      from
        lens_review as r
      where
        r.lens_arn = any(string_to_array($2, ','))
      group by
        r.milestone_number
      order by
        r.milestone_number
    ) select
      m.milestone_name,
      r.high_risks,
      r.medium_risks,
      r.no_improvements_risks,
      r.not_applicable_risks
    from
      risk_data r
      left join milestone_info m
        on r.milestone_number = m.milestone_number
    order by
      m.recorded_at;
  EOQ

  param "workload_id" {}
  param "lens_arn" {}
}

query "wellarchitected_workload_unanswered_by_milestone" {
  sql = <<-EOQ
    with milestone_info as (
      select
        workload_id,
        milestone_number,
        milestone_name,
        recorded_at
      from
        aws_wellarchitected_milestone
      where
        workload_id = $1

      union

      select
        $1 as workload_id,
        0 as milestone_number, -- Lens review API returns latest milestone as 0
        'latest' as milestone_name,
        current_timestamp as recorded_at
    ), lens_review as (
      select
        *
      from
        aws_wellarchitected_lens_review
      where
        milestone_number in (select milestone_number from aws_wellarchitected_milestone where workload_id = $1 union select 0 as milestone_number) -- Latest milestone is returned as 0
        and workload_id = (select workload_id from aws_wellarchitected_workload where workload_id = $1)
    ), risk_data as (
      select
        milestone_number,
        sum((risk_counts ->> 'UNANSWERED')::int) as unanswered_risks
      from
        lens_review as r
      where
        r.lens_arn = any(string_to_array($2, ','))
      group by
        r.milestone_number
      order by
        r.milestone_number
    ) select
      m.milestone_name,
      r.unanswered_risks
    from
      risk_data r
      left join milestone_info m
        on r.milestone_number = m.milestone_number
    order by
      recorded_at;
  EOQ

  param "workload_id" {}
  param "lens_arn" {}
}

# Table queries

query "wellarchitected_workload_lens_risk_table" {
  sql = <<-EOQ
    select
      r.lens_name as "Lens Name",
      (r.risk_counts ->> 'HIGH')::int as "High",
      (r.risk_counts ->> 'MEDIUM')::int as "Medium",
      (r.risk_counts ->> 'NONE')::int as "No Improvements",
      (r.risk_counts ->> 'NOT_APPLICABLE')::int as "Not Applicable"
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

query "wellarchitected_workload_pillar_risk_table" {
  sql = <<-EOQ
    select
      p ->> 'PillarName' as "Pillar Name",
      sum((p -> 'RiskCounts' ->> 'HIGH')::int) as "High",
      sum((p -> 'RiskCounts' ->> 'MEDIUM')::int) as "Medium",
      sum((p -> 'RiskCounts' ->> 'NONE')::int) as "No Improvements",
      sum((p -> 'RiskCounts' ->> 'NOT_APPLICABLE')::int) as "Not Applicable"
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

query "wellarchitected_workload_milestone_risk_table" {
  sql = <<-EOQ
    with milestone_info as (
      select
        workload_id,
        milestone_number,
        milestone_name,
        recorded_at
      from
        aws_wellarchitected_milestone
      where
        workload_id = $1

      union

      select
        $1 as workload_id,
        0 as milestone_number, -- Lens review API returns latest milestone as 0
        'latest' as milestone_name,
        current_timestamp as recorded_at
    ), lens_review as (
      select
        *
      from
        aws_wellarchitected_lens_review
      where
        milestone_number in (select milestone_number from aws_wellarchitected_milestone where workload_id = $1 union select 0 as milestone_number) -- Latest milestone is returned as 0
        and workload_id = (select workload_id from aws_wellarchitected_workload where workload_id = $1)
    ), risk_data as (
      select
        milestone_number,
        sum((risk_counts ->> 'HIGH')::int) as high_risks,
        sum((risk_counts ->> 'MEDIUM')::int) as medium_risks,
        sum((risk_counts ->> 'NONE')::int) as no_improvements_risks,
        sum((risk_counts ->> 'NOT_APPLICABLE')::int) as not_applicable_risks
      from
        lens_review as r
      where
        r.lens_arn = any(string_to_array($2, ','))
      group by
        r.milestone_number
      order by
        r.milestone_number
    ) select
      case
        when m.milestone_number = 0 then null -- Instead of showing milestone number as 0 for latest, show null to avoid confusion
        else m.milestone_number
      end as "Milestone Number",
      case
        when m.milestone_number = 0 then 'latest'
        else m.milestone_name
      end as "Milestone Name",
      r.high_risks as "High",
      r.medium_risks as "Medium",
      r.no_improvements_risks as "No Improvements",
      r.not_applicable_risks as "Not Applicable",
      to_char(m.recorded_at, 'YYYY-MM-DD HH24:MI') as "Date Saved"
    from
      risk_data r
      left join milestone_info m
        on r.milestone_number = m.milestone_number
    order by
      m.recorded_at desc;
  EOQ

  param "workload_id" {}
  param "lens_arn" {}
}

query "wellarchitected_workload_milestone_unanswered_table" {
  sql = <<-EOQ
    with milestone_info as (
      select
        workload_id,
        milestone_number,
        milestone_name,
        recorded_at
      from
        aws_wellarchitected_milestone
      where
        workload_id = $1

      union

      select
        $1 as workload_id,
        0 as milestone_number, -- Lens review API returns latest milestone as 0
        'latest' as milestone_name,
        current_timestamp as recorded_at
    ), lens_review as (
      select
        *
      from
        aws_wellarchitected_lens_review
      where
        milestone_number in (select milestone_number from aws_wellarchitected_milestone where workload_id = $1 union select 0 as milestone_number) -- Latest milestone is returned as 0
        and workload_id = (select workload_id from aws_wellarchitected_workload where workload_id = $1)
    ), risk_data as (
      select
        milestone_number,
        sum((risk_counts ->> 'UNANSWERED')::int) as unanswered_risks
      from
        lens_review as r
      where
        r.lens_arn = any(string_to_array($2, ','))
      group by
        r.milestone_number
      order by
        r.milestone_number
    ) select
      case
        when m.milestone_number = 0 then null -- Instead of showing milestone number as 0 for latest, show null to avoid confusion
        else m.milestone_number
      end as "Milestone Number",
      case
        when m.milestone_number = 0 then 'latest'
        else m.milestone_name
      end as "Milestone Name",
      r.unanswered_risks as "Unanswered Questions",
      to_char(m.recorded_at, 'YYYY-MM-DD HH24:MI') as "Date Saved"
    from
      risk_data r
      left join milestone_info m
        on r.milestone_number = m.milestone_number
    order by
      recorded_at desc;
  EOQ

  param "workload_id" {}
  param "lens_arn" {}
}