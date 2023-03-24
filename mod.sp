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
  title         = "AWS Well Architected"
  description   = "TO-DO"
  color         = "#FF9900"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/aws_well_architected.svg"
  categories    = ["aws", "cis", "compliance", "pci dss", "public cloud", "security"]

  opengraph {
    title       = "Steampipe Mod for AWS Well Architected"
    description = "TO-DO"
    image       = "/images/mods/turbot/aws_well_architected_social_graphic.png"
  }

  require {
    steampipe = "0.19.1"
    plugin "aws"{
      version = "0.90"
    }
    mod "github.com/turbot/steampipe-mod-aws-compliance" {
      version = "v0.59+preview"
    }
  }
}
