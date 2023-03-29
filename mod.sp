// Benchmarks and controls for specific services should override the "service" tag
locals {
  aws_well_architected_common_tags = {
    category = "Compliance"
    plugin   = "aws"
    service  = "AWS"
  }
}

mod "aws_well_architected" {
  # hub metadata
  title         = "AWS Well-Architected"
  description   = "Run individual configuration, compliance and security controls or full compliance benchmarks for Well-Architected framework controls across all your AWS accounts using Steampipe."
  color         = "#FF9900"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/aws-compliance.svg"
  categories    = ["aws", "compliance", "public cloud", "security"]

  opengraph {
    title       = "Steampipe Mod for AWS Well-Architected"
    description = "Run individual configuration, compliance and security controls or full compliance benchmarks for Well-Architected framework controls across all your AWS accounts using Steampipe."
    image       = "/images/mods/turbot/aws-compliance-social-graphic.png"
  }

  require {
    steampipe = "0.19.1"
    plugin "aws"{
      version = "0.97"
    }
    mod "github.com/turbot/steampipe-mod-aws-compliance" {
      version = "v0.59"
    }
  }
}
