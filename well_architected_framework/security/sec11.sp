locals {
  well_architected_framework_sec11_common_tags = merge(local.well_architected_framework_security_common_tags, {
    question_id = "application-security"
  })
}

benchmark "well_architected_framework_sec11" {
  title       = "SEC11 How do you incorporate and validate the security properties of applications throughout the design, development, and deployment lifecycle?"
  description = "Preparation is critical to timely and effective investigation, response to, and recovery from security incidents to help minimize disruption to your organization."
  children = [
    benchmark.well_architected_framework_sec11_bp02
  ]

  tags = local.well_architected_framework_sec11_common_tags
}

benchmark "well_architected_framework_sec11_bp02" {
  title       = "BP01 Identify key personnel and external resources"
  description = "Training people, testing using automation, understanding dependencies, and validating the security properties of tools and applications help to reduce the likelihood of security issues in production workloads."
  children = [
    aws_compliance.control.ecr_repository_image_scan_on_push_enabled
  ]

  tags = merge(local.well_architected_framework_sec11_common_tags, {
    choice_id = "sec_appsec_automate_testing_throughout_lifecycle"
    severity  = "medium"
  })
}
