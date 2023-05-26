locals {
  well_architected_framework_sec09_common_tags = merge(local.well_architected_framework_security_common_tags, {
    question_id = "protect-data-transit"
  })
}

benchmark "well_architected_framework_sec09" {
  title       = "SEC09 How do you protect your data in transit?"
  description = "Protect your data in transit by implementing multiple controls to reduce the risk of unauthorized access or loss."
  children = [
    benchmark.well_architected_framework_sec09_bp01,
    benchmark.well_architected_framework_sec09_bp02,
    benchmark.well_architected_framework_sec09_bp03,
    benchmark.well_architected_framework_sec09_bp04
  ]

  tags = local.well_architected_framework_sec09_common_tags
}

benchmark "well_architected_framework_sec09_bp01" {
  title       = "BP01 Implement secure key and certificate management"
  description = "Store encryption keys and certificates securely and rotate them at appropriate time intervals with strict access control. The best way to accomplish this is to use a managed service, such as AWS Certificate Manager (ACM). It lets you easily provision, manage, and deploy public and private Transport Layer Security (TLS) certificates for use with AWS services and your internal connected resources. TLS certificates are used to secure network communications and establish the identity of websites over the internet as well as resources on private networks. ACM integrates with AWS resources, such as Elastic Load Balancers (ELBs), AWS distributions, and APIs on API Gateway, also handling automatic certificate renewals. If you use ACM to deploy a private root CA, both certificates and private keys can be provided by it for use in Amazon Elastic Compute Cloud (Amazon EC2) instances, containers, and so on."
  children = [
    aws_compliance.control.acm_certificate_expires_30_days,
    aws_compliance.control.elb_classic_lb_use_ssl_certificate,
    aws_compliance.control.elb_application_network_lb_use_ssl_certificate
  ]

  tags = merge(local.well_architected_framework_sec09_common_tags, {
    choice_id = "sec_protect_data_transit_key_cert_mgmt"
    severity  = "high"
  })
}

benchmark "well_architected_framework_sec09_bp02" {
  title       = "BP02 Enforce encryption in transit"
  description = "Enforce your defined encryption requirements based on your organization's policies, regulatory obligations and standards to help meet organizational, legal, and compliance requirements. Only use protocols with encryption when transmitting sensitive data outside of your virtual private cloud (VPC). Encryption helps maintain data confidentiality even when the data transits untrusted networks. All data should be encrypted in transit using secure TLS protocols and cipher suites. Network traffic between your resources and the internet must be encrypted to mitigate unauthorized access to the data. Network traffic solely within your internal AWS environment should be encrypted using TLS wherever possible."
  children = [
    aws_compliance.control.elb_application_lb_drop_http_headers,
    aws_compliance.control.elb_application_lb_redirect_http_request_to_https,
    aws_compliance.control.es_domain_node_to_node_encryption_enabled,
    aws_compliance.control.apigateway_rest_api_stage_use_ssl_certificate,
    aws_compliance.control.opensearch_domain_node_to_node_encryption_enabled,
    aws_compliance.control.opensearch_domain_https_required,
    aws_compliance.control.cloudfront_distribution_custom_origins_encryption_in_transit_enabled,
    aws_compliance.control.cloudfront_distribution_no_deprecated_ssl_protocol,
    aws_compliance.control.elb_listener_use_secure_ssl_cipher,
    aws_compliance.control.s3_bucket_enforces_ssl
  ]

  tags = merge(local.well_architected_framework_sec09_common_tags, {
    choice_id = "sec_protect_data_transit_encrypt"
    severity  = "high"
  })
}

benchmark "well_architected_framework_sec09_bp03" {
  title       = "BP03 Automate detection of unintended data access"
  description = "Use tools such as Amazon GuardDuty to automatically detect suspicious activity or attempts to move data outside of defined boundaries. For example, GuardDuty can detect Amazon Simple Storage Service (Amazon S3) read activity that is unusual with the Exfiltration:S3/AnomalousBehavior finding. In addition to GuardDuty, Amazon VPC Flow Logs, which capture network traffic information, can be used with Amazon EventBridge to detect connections, both successful and denied. Amazon S3 Access Analyzer can help assess what data is accessible to who in your Amazon S3 buckets."
  children = [
    aws_compliance.control.redshift_cluster_encryption_in_transit_enabled
  ]

  tags = merge(local.well_architected_framework_sec09_common_tags, {
    choice_id = "sec_protect_data_transit_auto_unintended_access"
    severity  = "medium"
  })
}

benchmark "well_architected_framework_sec09_bp04" {
  title       = "BP04 Authenticate network communications"
  description = "Verify the identity of communications by using protocols that support authentication, such as Transport Layer Security (TLS) or IPsec. Using network protocols that support authentication, allows for trust to be established between the parties. This adds to the encryption used in the protocol to reduce the risk of communications being altered or intercepted. Common protocols that implement authentication include Transport Layer Security (TLS), which is used in many AWS services, and IPsec, which is used in AWS Virtual Private Network (AWS VPN)."
  children = [
    aws_compliance.control.elb_classic_lb_use_tls_https_listeners,
    aws_compliance.control.vpc_flow_logs_enabled
  ]

  tags = merge(local.well_architected_framework_sec09_common_tags, {
    choice_id = "sec_protect_data_transit_authentication"
    severity  = "low"
  })
}
