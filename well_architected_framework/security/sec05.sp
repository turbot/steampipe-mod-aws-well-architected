locals {
  well_architected_framework_sec05_common_tags = merge(local.well_architected_framework_security_common_tags, {
    question_id = "network-protection"
  })
}

benchmark "well_architected_framework_sec05" {
  title       = "SEC05 How do you protect your network resources?"
  description = "Any workload that has some form of network connectivity, whether it's the internet or a private network, requires multiple layers of defense to help protect from external and internal network-based threats."
  children = [
    benchmark.well_architected_framework_sec05_bp01,
    benchmark.well_architected_framework_sec05_bp02,
    benchmark.well_architected_framework_sec05_bp03,
    benchmark.well_architected_framework_sec05_bp04
  ]

  tags = local.well_architected_framework_sec05_common_tags
}

benchmark "well_architected_framework_sec05_bp01" {
  title       = "BP01 Create network layers"
  description = "Group components that share sensitivity requirements into layers to minimize the potential scope of impact of unauthorized access. For example, a database cluster in a virtual private cloud (VPC) with no need for internet access should be placed in subnets with no route to or from the internet. Traffic should only flow from the adjacent next least sensitive resource. Consider a web application sitting behind a load balancer. Your database should not be accessible directly from the load balancer. Only the business logic or web server should have direct access to your database."
  children = [
    aws_compliance.control.es_domain_in_vpc,
    aws_compliance.control.opensearch_domain_in_vpc,
    aws_compliance.control.ec2_instance_in_vpc,
    aws_compliance.control.lambda_function_in_vpc,
    aws_compliance.control.redshift_cluster_enhanced_vpc_routing_enabled,
    aws_compliance.control.elb_application_lb_waf_enabled,
    aws_compliance.control.apigateway_stage_use_waf_web_acl,
    aws_compliance.control.cloudfront_distribution_waf_enabled,
    aws_compliance.control.eks_cluster_endpoint_restrict_public_access,
    aws_compliance.control.sagemaker_model_network_isolation_enabled,
    aws_compliance.control.sagemaker_model_in_vpc,
    aws_compliance.control.sagemaker_notebook_instance_in_vpc,
    aws_compliance.control.sagemaker_training_job_network_isolation_enabled,
    aws_compliance.control.sagemaker_training_job_in_vpc
  ]

  tags = merge(local.well_architected_framework_sec05_common_tags, {
    choice_id = "sec_network_protection_create_layers"
    severity  = "high"
  })
}

benchmark "well_architected_framework_sec05_bp02" {
  title       = "BP02 Control traffic at all layers"
  description = "When architecting your network topology, you should examine the connectivity requirements of each component. For example, if a component requires internet accessibility (inbound and outbound), connectivity to VPCs, edge services, and external data centers. A VPC allows you to define your network topology that spans an AWS Region with a private IPv4 address range that you set, or an IPv6 address range AWS selects. You should apply multiple controls with a defense in depth approach for both inbound and outbound traffic, including the use of security groups (stateful inspection firewall), Network ACLs, subnets, and route tables. Within a VPC, you can create subnets in an Availability Zone. Each subnet can have an associated route table that defines routing rules for managing the paths that traffic takes within the subnet. You can define an internet routable subnet by having a route that goes to an internet or NAT gateway attached to the VPC, or through another VPC."
  children = [
    aws_compliance.control.dms_replication_instance_not_publicly_accessible,
    aws_compliance.control.ebs_snapshot_not_publicly_restorable,
    aws_compliance.control.ec2_instance_not_use_multiple_enis,
    aws_compliance.control.sagemaker_notebook_instance_direct_internet_access_disabled,
    aws_compliance.control.vpc_subnet_auto_assign_public_ip_disabled,
    aws_compliance.control.vpc_default_security_group_restricts_all_traffic,
    aws_compliance.control.apigateway_rest_api_authorizers_configured,
    aws_compliance.control.s3_bucket_acls_should_prohibit_user_access,
    aws_compliance.control.cis_v150_2_1_3
  ]

  tags = merge(local.well_architected_framework_sec05_common_tags, {
    choice_id = "sec_network_protection_layered"
    severity  = "high"
  })
}

benchmark "well_architected_framework_sec05_bp03" {
  title       = "BP03 Automate network protection"
  description = "Automate protection mechanisms to provide a self-defending network based on threat intelligence and anomaly detection. For example, intrusion detection and prevention tools that can adapt to current threats and reduce their impact. A web application firewall is an example of where you can automate network protection, for example, by using the AWS WAF Security Automations solution to automatically block requests originating from IP addresses associated with known threat actors."
  children = [
    aws_compliance.control.dms_replication_instance_not_publicly_accessible,
    aws_compliance.control.autoscaling_launch_config_public_ip_disabled,
    aws_compliance.control.vpc_network_acl_remote_administration,
    aws_compliance.control.vpc_security_group_allows_ingress_authorized_ports,
    aws_compliance.control.cis_v150_5_2,
    aws_compliance.control.vpc_security_group_restrict_ingress_tcp_udp_all,
    aws_compliance.control.vpc_security_group_restrict_ingress_common_ports_all,
    aws_compliance.control.vpc_security_group_restrict_ingress_kafka_port,
    aws_compliance.control.vpc_security_group_restricted_common_ports,
    aws_compliance.control.vpc_security_group_restrict_ingress_redis_port,
    aws_compliance.control.waf_web_acl_rule_attached,
    aws_compliance.control.waf_rule_group_rule_attached,
    aws_compliance.control.vpc_network_acl_unused,
    aws_compliance.control.vpc_default_security_group_restricts_all_traffic,
    aws_compliance.control.ec2_instance_no_launch_wizard_security_group,
    aws_compliance.control.route53_domain_privacy_protection_enabled,
    aws_compliance.control.route53_domain_transfer_lock_enabled
  ]

  tags = merge(local.well_architected_framework_sec05_common_tags, {
    choice_id = "sec_network_protection_auto_protect"
    severity  = "medium"
  })
}

benchmark "well_architected_framework_sec05_bp04" {
  title       = "BP04 Implement inspection and protection"
  description = "Inspect and filter your traffic at each layer. You can inspect your VPC configurations for potential unintended access using VPC Network Access Analyzer. You can specify your network access requirements and identify potential network paths that do not meet them. For components transacting over HTTP-based protocols, a web application firewall can help protect from common attacks. AWS WAF is a web application firewall that lets you monitor and block HTTP(s) requests that match your configurable rules that are forwarded to an Amazon API Gateway API, Amazon CloudFront, or an Application Load Balancer. To get started with AWS WAF, you can use AWS Managed Rules in combination with your own, or use existing partner integrations."
  children = [
    aws_compliance.control.guardduty_enabled,
    aws_compliance.control.vpc_flow_logs_enabled,
    aws_compliance.control.apigateway_rest_api_authorizers_configured
  ]

  tags = merge(local.well_architected_framework_sec05_common_tags, {
    choice_id = "sec_network_protection_inspection"
    severity  = "low"
  })
}
