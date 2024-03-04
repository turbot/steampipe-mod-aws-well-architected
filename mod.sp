mod "aws_well_architected" {
  # Hub metadata
  title         = "AWS Well-Architected"
  description   = "Run controls across all of your AWS accounts to check if they are following AWS Well-Architected best practices using Powerpipe and Steampipe."
  color         = "#FF9900"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/aws-well-architected.svg"
  categories    = ["aws", "compliance", "public cloud", "security"]

  opengraph {
    title       = "Powerpipe Mod for AWS Well-Architected"
    description = "Run controls across all of your AWS accounts to check if they are following AWS Well-Architected best practices using Powerpipe and Steampipe."
    image       = "/images/mods/turbot/aws-well-architected-social-graphic.png"
  }

  require {
    plugin "aws" {
      min_version = "0.101.0"
    }
    mod "github.com/turbot/steampipe-mod-aws-compliance" {
      version = ">=0.66.0"
      args = {
        common_dimensions = var.common_dimensions,
        tag_dimensions    = var.tag_dimensions
      }
    }
  }
}
