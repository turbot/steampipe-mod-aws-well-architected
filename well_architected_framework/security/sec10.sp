locals {
  well_architected_framework_sec10_common_tags = merge(local.well_architected_framework_security_common_tags, {
    question_id = "incident-response"
  })
}

benchmark "well_architected_framework_sec10" {
  title       = "SEC10 How do you anticipate, respond to, and recover from incidents?"
  description = "Preparation is critical to timely and effective investigation, response to, and recovery from security incidents to help minimize disruption to your organization."
  children = [
    benchmark.well_architected_framework_sec10_bp01
  ]

  tags = local.well_architected_framework_sec10_common_tags
}

benchmark "well_architected_framework_sec10_bp01" {
  title       = "BP01 Identify key personnel and external resources"
  description = "Identify internal and external personnel, resources, and legal obligations that would help your organization respond to an incident. When you define your approach to incident response in the cloud, in unison with other teams (such as your legal counsel, leadership, business stakeholders, AWS Support Services, and others), you must identify key personnel, stakeholders, and relevant contacts. To reduce dependency and decrease response time, make sure that your team, specialist security teams, and responders are educated about the services that you use and have opportunities to practice hands-on."
  children = [
    aws_compliance.control.iam_support_role
  ]

  tags = merge(local.well_architected_framework_sec10_common_tags, {
    choice_id = "sec_incident_response_identify_personnel"
    severity  = "high"
  })
}
