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
  description   = "Run controls across all of your AWS accounts to check if they are following AWS Well-Architected Framework best practices using Steampipe."
  color         = "#FF9900"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/aws-well-architected.svg"
  categories    = ["aws", "compliance", "public cloud", "security"]

  opengraph {
    title       = "Steampipe Mod for AWS Well-Architected"
  description   = "Run controls across all of your AWS accounts to check if they are following AWS Well-Architected Framework best practices using Steampipe."
    image       = "/images/mods/turbot/aws-well-architected-social-graphic.png"
  }

  require {
    mod "github.com/turbot/steampipe-mod-aws-compliance" {
      version = "^0.59.0"
    }
  }
}
