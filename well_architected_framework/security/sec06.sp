locals {
  well_architected_framework_security_sec06_common_tags = merge(local.well_architected_framework_security_common_tags, {
    question_id = "protect-compute"
  })
}

benchmark "well_architected_framework_security_sec06" {
  title       = "SEC06 How do you protect your compute resources?"
  description = "Compute resources in your workload require multiple layers of defense to help protect from external and internal threats. Compute resources include EC2 instances, containers, AWS Lambda functions, database services, IoT devices, and more."
  children = [
    benchmark.well_architected_framework_security_sec06_bp01,
    benchmark.well_architected_framework_security_sec06_bp02,
    benchmark.well_architected_framework_security_sec06_bp03,
    benchmark.well_architected_framework_security_sec06_bp04,
    benchmark.well_architected_framework_security_sec06_bp05,
    benchmark.well_architected_framework_security_sec06_bp06
  ]

  tags = local.well_architected_framework_security_sec06_common_tags
}

benchmark "well_architected_framework_security_sec06_bp01" {
  title       = "BP01 Perform vulnerability management"
  description = "Frequently scan and patch for vulnerabilities in your code, dependencies, and in your infrastructure to help protect against new threats. Create and maintain a vulnerability management program. Regularly scan and patch resources such as Amazon EC2 instances, Amazon Elastic Container Service (Amazon ECS) containers, and Amazon Elastic Kubernetes Service (Amazon EKS) workloads. Configure maintenance windows for AWS managed resources, such as Amazon Relational Database Service (Amazon RDS) databases. Use static code scanning to inspect application source code for common issues. Consider web application penetration testing if your organization has the requisite skills or can hire outside assistance."
  children = [
    aws_compliance.control.rds_db_instance_automatic_minor_version_upgrade_enabled,
    aws_compliance.control.cloudtrail_trail_validation_enabled,
    aws_compliance.control.cloudtrail_security_trail_enabled,
    aws_compliance.control.ec2_instance_uses_imdsv2,
    aws_compliance.control.ec2_instance_publicly_accessible_iam_profile_attached,
    aws_compliance.control.foundational_security_redshift_6,
    aws_compliance.control.ssm_managed_instance_compliance_patch_compliant
  ]

  tags = merge(local.well_architected_framework_security_sec06_common_tags, {
    choice_id = "sec_protect_compute_vulnerability_management"
    severity  = "high"
  })
}

benchmark "well_architected_framework_security_sec06_bp02" {
  title       = "BP02 Reduce attack surface"
  description = "Reduce your exposure to unintended access by hardening operating systems and minimizing the components, libraries, and externally consumable services in use. Start by reducing unused components, whether they are operating system packages or applications, for Amazon Elastic Compute Cloud (Amazon EC2)-based workloads, or external software modules in your code, for all workloads. You can find many hardening and security configuration guides for common operating systems and server software. For example, you can start with the Center for Internet Security and iterate."
  children = [
    aws_compliance.control.lambda_function_in_vpc,
    aws_compliance.control.ecs_cluster_container_insights_enabled,
    aws_compliance.control.ecs_service_fargate_using_latest_platform_version
  ]

  tags = merge(local.well_architected_framework_security_sec06_common_tags, {
    choice_id = "sec_protect_compute_reduce_surface"
    severity  = "high"
  })
}

benchmark "well_architected_framework_security_sec06_bp03" {
  title       = "BP03 Implement managed services"
  description = "Implement services that manage resources, such as Amazon Relational Database Service (Amazon RDS), AWS Lambda, and Amazon Elastic Container Service (Amazon ECS), to reduce your security maintenance tasks as part of the shared responsibility model. For example, Amazon RDS helps you set up, operate, and scale a relational database, automates administration tasks such as hardware provisioning, database setup, patching, and backups. This means you have more free time to focus on securing your application in other ways described in the AWS Well-Architected Framework. Lambda lets you run code without provisioning or managing servers, so you only need to focus on the connectivity, invocation, and security at the code level–not the infrastructure or operating system."
  children = [
    aws_compliance.control.redshift_cluster_maintenance_settings_check,
    aws_compliance.control.ec2_instance_not_use_multiple_enis
  ]

  tags = merge(local.well_architected_framework_security_sec06_common_tags, {
    choice_id = "sec_protect_compute_implement_managed_services"
    severity  = "medium"
  })
}

benchmark "well_architected_framework_security_sec06_bp04" {
  title       = "BP04 Automate compute protection"
  description = "Automate your protective compute mechanisms including vulnerability management, reduction in attack surface, and management of resources. The automation will help you invest time in securing other aspects of your workload, and reduce the risk of human error."
  children = [
    aws_compliance.control.ec2_instance_iam_profile_attached,
    aws_compliance.control.ec2_instance_ssm_managed,
    aws_compliance.control.ec2_instance_not_use_multiple_enis,
    aws_compliance.control.ec2_stopped_instance_30_days
  ]

  tags = merge(local.well_architected_framework_security_sec06_common_tags, {
    choice_id = "sec_protect_compute_auto_protection"
    severity  = "medium"
  })
}

benchmark "well_architected_framework_security_sec06_bp05" {
  title       = "BP05 Enable people to perform actions at a distance"
  description = "Removing the ability for interactive access reduces the risk of human error, and the potential for manual configuration or management. For example, use a change management workflow to deploy Amazon Elastic Compute Cloud (Amazon EC2) instances using infrastructure-as-code, then manage Amazon EC2 instances using tools such as AWS Systems Manager instead of allowing direct access or through a bastion host. AWS Systems Manager can automate a variety of maintenance and deployment tasks, using features including automation workflows, documents (playbooks), and the run command. AWS CloudFormation stacks build from pipelines and can automate your infrastructure deployment and management tasks without using the AWS Management Console or APIs directly."
  children = [
    aws_compliance.control.ec2_instance_iam_profile_attached,
    aws_compliance.control.ec2_instance_ssm_managed,
    aws_compliance.control.ec2_instance_not_use_multiple_enis,
    aws_compliance.control.ec2_stopped_instance_30_days
  ]

  tags = merge(local.well_architected_framework_security_sec06_common_tags, {
    choice_id = "sec_protect_compute_actions_distance"
    severity  = "low"
  })
}

benchmark "well_architected_framework_security_sec06_bp06" {
  title       = "BP06 Validate software integrity"
  description = "Implement mechanisms (for example, code signing) to validate that the software, code and libraries used in the workload are from trusted sources and have not been tampered with. For example, you should verify the code signing certificate of binaries and scripts to confirm the author, and ensure it has not been tampered with since created by the author. AWS Signer can help ensure the trust and integrity of your code by centrally managing the code- signing lifecycle, including signing certification and public and private keys. You can learn how to use advanced patterns and best practices for code signing with AWS Lambda. Additionally, a checksum of software that you download, compared to that of the checksum from the provider, can help ensure it has not been tampered with."
  children = [
    aws_compliance.control.ebs_volume_unused,
    aws_compliance.control.ssm_managed_instance_compliance_association_compliant,
    aws_compliance.control.ssm_managed_instance_compliance_patch_compliant,
    aws_compliance.control.cloudtrail_trail_validation_enabled
  ]

  tags = merge(local.well_architected_framework_security_sec06_common_tags, {
    choice_id = "sec_protect_compute_validate_software_integrity"
    severity  = "low"
  })
}
