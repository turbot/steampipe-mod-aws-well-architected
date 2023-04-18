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
      query = query.wellarchitected_workload_high_risks_count
      args  = [self.input.workload_arn.value]
    }

    card {
      width = 2
      query = query.wellarchitected_workload_medium_risks_count
      args  = [self.input.workload_arn.value]
    }

  }

  container {

    chart {
      type  = "column"
      title = "Risk Counts by Lens"
      #grouping = "compare"
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
        title = "No Risk"
        color = "green"
      }

      series not_applicable_risks {
        title = "N/A"
        color = "blue"
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
      #grouping = "compare"
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
        title = "No Risk"
        color = "green"
      }

      series not_applicable_risks {
        title = "N/A"
        color = "blue"
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
  /*
  */

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
      (risk_counts ->> 'HIGH')::int as value,
      case
        (risk_counts ->> 'HIGH')::int when 0 then 'ok'
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
      (risk_counts ->> 'MEDIUM')::int as value,
      case
        (risk_counts ->> 'MEDIUM')::int when 0 then 'ok'
        else 'alert'
      end as type
    from
      aws_wellarchitected_workload
    where
      workload_arn = $1;
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
      (r.risk_counts ->> 'NOT_APPLICABLE')::int as not_applicable_risks,
      (r.risk_counts ->> 'UNANSWERED')::int as unanswered_risks
    from
      aws_wellarchitected_lens_review as r,
      workload_info as w
    where
      r.workload_id = w.workload_id
    group by
      r.lens_name,
      r.risk_counts
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
      (p -> 'RiskCounts' ->> 'HIGH')::int as high_risks,
      (p -> 'RiskCounts' ->> 'MEDIUM')::int as medium_risks,
      (p -> 'RiskCounts' ->> 'NONE')::int as none_risks,
      (p -> 'RiskCounts' ->> 'NOT_APPLICABLE')::int as not_applicable_risks,
      (p -> 'RiskCounts' ->> 'UNANSWERED')::int as unanswered_risks
    from
      aws_wellarchitected_lens_review as r,
      jsonb_array_elements(r.pillar_review_summaries) as p,
      workload_info as w
    where
      r.workload_id = w.workload_id
    group by
      pillar_name,
      p -> 'RiskCounts'
  EOQ
}


# With queries

/*
query "ebs_volumes_for_ec2_instance" {
  sql = <<-EOQ
    select
      v.arn as volume_arn
    from
      aws_ec2_instance as i,
      jsonb_array_elements(block_device_mappings) as bd,
      aws_ebs_volume as v
    where
      v.volume_id = bd -> 'Ebs' ->> 'VolumeId'
      and i.arn = $1;
  EOQ
}

query "ec2_application_load_balancers_for_ec2_instance" {
  sql = <<-EOQ
    select
      distinct lb.arn as application_load_balancer_arn
    from
      aws_ec2_instance as i,
      aws_ec2_target_group as target,
      jsonb_array_elements(target.target_health_descriptions) as health_descriptions,
      jsonb_array_elements_text(target.load_balancer_arns) as l,
      aws_ec2_application_load_balancer as lb
    where
      health_descriptions -> 'Target' ->> 'Id' = i.instance_id
      and l = lb.arn
      and i.arn = $1;
  EOQ
}

query "ec2_classic_load_balancers_for_ec2_instance" {
  sql = <<-EOQ
    select
      distinct clb.arn as classic_load_balancer_arn
    from
      aws_ec2_classic_load_balancer as clb,
      jsonb_array_elements(clb.instances) as instance,
      aws_ec2_instance as i
    where
      i.arn = $1
      and instance ->> 'InstanceId' = i.instance_id;
  EOQ
}

query "ec2_gateway_load_balancers_for_ec2_instance" {
  sql = <<-EOQ
    select
      distinct lb.arn as gateway_load_balancer_arn
    from
      aws_ec2_instance as i,
      aws_ec2_target_group as target,
      jsonb_array_elements(target.target_health_descriptions) as health_descriptions,
      jsonb_array_elements_text(target.load_balancer_arns) as l,
      aws_ec2_gateway_load_balancer as lb
    where
      health_descriptions -> 'Target' ->> 'Id' = i.instance_id
      and l = lb.arn
      and i.arn = $1;
  EOQ
}

query "ec2_network_interfaces_for_ec2_instance" {
  sql = <<-EOQ
    select
      network_interface ->> 'NetworkInterfaceId' as network_interface_id
    from
      aws_ec2_instance as i,
      jsonb_array_elements(network_interfaces) as network_interface
    where
      i.arn = $1;
  EOQ
}

query "ec2_network_load_balancers_for_ec2_instance" {
  sql = <<-EOQ
    select
      distinct lb.arn as network_load_balancer_arn
    from
      aws_ec2_instance as i,
      aws_ec2_target_group as target,
      jsonb_array_elements(target.target_health_descriptions) as health_descriptions,
      jsonb_array_elements_text(target.load_balancer_arns) as l,
      aws_ec2_network_load_balancer as lb
    where
      health_descriptions -> 'Target' ->> 'Id' = i.instance_id
      and l = lb.arn
      and i.arn = $1;
  EOQ
}

query "ec2_target_groups_for_ec2_instance" {
  sql = <<-EOQ
    select
      target.target_group_arn
    from
      aws_ec2_instance as i,
      aws_ec2_target_group as target,
      jsonb_array_elements(target.target_health_descriptions) as health_descriptions
    where
      i.arn = $1
      and health_descriptions -> 'Target' ->> 'Id' = i.instance_id;
  EOQ
}

query "ecs_clusters_for_ec2_instance" {
  sql = <<-EOQ
    select
      distinct cluster.cluster_arn as cluster_arn
    from
      aws_ec2_instance as i,
      aws_ecs_container_instance as ci,
      aws_ecs_cluster as cluster
    where
      ci.ec2_instance_id = i.instance_id
      and ci.cluster_arn = cluster.cluster_arn
      and i.arn = $1;
  EOQ
}

query "iam_roles_for_ec2_instance" {
  sql = <<-EOQ
    select
      distinct r.arn as role_arn
    from
      aws_ec2_instance as i,
      aws_iam_role as r,
      jsonb_array_elements_text(instance_profile_arns) as instance_profile
    where
      instance_profile = i.iam_instance_profile_arn
      and i.arn = $1;
  EOQ
}

query "vpc_eips_for_ec2_instance" {
  sql = <<-EOQ
    select
      e.arn as eip_arn
    from
      aws_vpc_eip as e,
      aws_ec2_instance as i
    where
      e.instance_id = i.instance_id
      and i.arn = $1;
  EOQ
}

query "vpc_security_groups_for_ec2_instance" {
  sql = <<-EOQ
    select
      sg ->> 'GroupId' as security_group_id
    from
      aws_ec2_instance as i,
      jsonb_array_elements(security_groups) as sg
    where
      arn = $1;
  EOQ
}

query "vpc_subnets_for_ec2_instance" {
  sql = <<-EOQ
    select
      subnet_id as subnet_id
    from
      aws_ec2_instance as i
    where
      arn = $1;
  EOQ
}

query "vpc_vpcs_for_ec2_instance" {
  sql = <<-EOQ
    select
      vpc_id as vpc_id
    from
      aws_ec2_instance
    where
      arn = $1;
  EOQ
}

# Card queries

query "ec2_instance_status" {
  sql = <<-EOQ
    select
      'Status' as label,
      initcap(instance_state) as value
    from
      aws_ec2_instance
    where
      arn = $1;
  EOQ
}

query "ec2_instance_type" {
  sql = <<-EOQ
    select
      'Type' as label,
      instance_type as value
    from
      aws_ec2_instance
    where
      arn = $1;
  EOQ
}

query "ec2_instance_total_cores_count" {
  sql = <<-EOQ
    select
      'Total Cores' as label,
      sum(cpu_options_core_count) as value
    from
      aws_ec2_instance
    where
      arn = $1;
  EOQ
}

query "ec2_instance_public_access" {
  sql = <<-EOQ
    select
      'Public IP Address' as label,
      case when public_ip_address is null then 'Disabled' else host(public_ip_address) end as value,
      case when public_ip_address is null then 'ok' else 'alert' end as type
    from
      aws_ec2_instance
    where
      arn = $1;
  EOQ
}

query "ec2_instance_ebs_optimized" {
  sql = <<-EOQ
    select
      'EBS Optimized' as label,
      case when ebs_optimized then 'Enabled' else 'Disabled' end as value,
      case when ebs_optimized then 'ok' else 'alert' end as type
    from
      aws_ec2_instance
    where
      arn = $1;
  EOQ
}

# Misc queries

query "ec2_instance_overview" {
  sql = <<-EOQ
    select
      tags ->> 'Name' as "Name",
      instance_id as "Instance ID",
      launch_time as "Launch Time",
      title as "Title",
      region as "Region",
      account_id as "Account ID",
      arn as "ARN"
    from
      aws_ec2_instance
    where
      arn = $1;
  EOQ
}

query "ec2_instance_tags" {
  sql = <<-EOQ
    select
      tag ->> 'Key' as "Key",
      tag ->> 'Value' as "Value"
    from
      aws_ec2_instance,
      jsonb_array_elements(tags_src) as tag
    where
      arn = $1
    order by
      tag ->> 'Key';
    EOQ
}

query "ec2_instance_block_device_mapping" {
  sql = <<-EOQ
    with volume_details as (
    select
      p -> 'Ebs' ->> 'VolumeId'  as "Volume ID",
      p ->> 'DeviceName'  as "Device Name",
      p -> 'Ebs' ->> 'AttachTime' as "Attach Time",
      p -> 'Ebs' ->> 'DeleteOnTermination' as "Delete On Termination",
      p -> 'Ebs' ->> 'Status'  as "Status",
      arn
    from
      aws_ec2_instance,
      jsonb_array_elements(block_device_mappings) as p
    where
      arn = $1
    )
    select
      "Volume ID",
      "Device Name",
      "Attach Time",
      "Delete On Termination",
      "Status",
      v.arn as "Volume ARN"
    from
      volume_details as vd
      left join aws_ebs_volume v on v.volume_id = vd."Volume ID"
    where
      v.volume_id in (select "Volume ID" from volume_details)
  EOQ
}

query "ec2_instance_security_groups" {
  sql = <<-EOQ
    select
      p ->> 'GroupId'  as "Group ID",
      p ->> 'GroupName' as "Group Name"
    from
      aws_ec2_instance,
      jsonb_array_elements(security_groups) as p
    where
      arn = $1;
  EOQ
}

query "ec2_instance_network_interfaces" {
  sql = <<-EOQ
    select
      p ->> 'NetworkInterfaceId' as "Network Interface ID",
      p ->> 'InterfaceType' as "Interface Type",
      ips -> 'Association' ->> 'PublicIp' as "Public IP Address",
      ips ->> 'PrivateIpAddress' as "Private IP Address",
      p ->> 'Status' as "Status",
      p ->> 'SubnetId' as "Subnet ID",
      p ->> 'VpcId' as "VPC ID"
    from
      aws_ec2_instance,
      jsonb_array_elements(network_interfaces) as p,
      jsonb_array_elements(p -> 'PrivateIpAddresses') as ips
    where
      arn = $1;
  EOQ
}

query "ec2_instance_cpu_cores" {
  sql = <<-EOQ
    select
      cpu_options_core_count  as "CPU Options Core Count",
      cpu_options_threads_per_core  as "CPU Options Threads Per Core"
    from
      aws_ec2_instance
    where
      arn = $1;
  EOQ
}
*/
