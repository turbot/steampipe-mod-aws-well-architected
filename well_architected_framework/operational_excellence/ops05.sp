locals {
  well_architected_framework_ops05_common_tags = merge(local.well_architected_framework_operational_excellence_common_tags, {
    question_id = "dev-integ"
  })
}

benchmark "well_architected_framework_ops05" {
  title       = "OPS05 How do you reduce defects, ease remediation, and improve flow into production?"
  description = "Adopt approaches that improve flow of changes into production, that enable refactoring, fast feedback on quality, and bug fixing. These accelerate beneficial changes entering production, limit issues deployed, and enable rapid identification and remediation of issues introduced through deployment activities."
  children = [
    benchmark.well_architected_framework_ops05_bp03,
    benchmark.well_architected_framework_ops05_bp05
  ]

  tags = local.well_architected_framework_ops05_common_tags
}

benchmark "well_architected_framework_ops05_bp03" {
  title       = "BP03 Use configuration management systems"
  description = "Use configuration management systems to make and track configuration changes. These systems reduce errors caused by manual processes and reduce the level of effort to deploy changes."

  children = [
    aws_compliance.control.config_enabled_all_regions
  ]

  tags = merge(local.well_architected_framework_ops05_common_tags, {
    choice_id = "ops_dev_integ_conf_mgmt_sys"
    risk      = "medium"
  })
}

benchmark "well_architected_framework_ops05_bp05" {
  title       = "BP05 Perform patch management"
  description = "Perform patch management to gain features, address issues, and remain compliant with governance. Automate patch management to reduce errors caused by manual processes, and reduce the level of effort to patch."

  children = [
    aws_compliance.control.ssm_managed_instance_compliance_patch_compliant
  ]

  tags = merge(local.well_architected_framework_ops05_common_tags, {
    choice_id = "ops_dev_integ_patch_mgmt"
    risk      = "medium"
  })
}
