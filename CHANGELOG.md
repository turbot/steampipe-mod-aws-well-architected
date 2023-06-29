## v0.8 [2023-05-26]

_Breaking changes_

- The standalone Well-Architected Framework Reliability and Security benchmarks have been removed, as they are now included in the Well-Architected Framework benchmark.

_What's new?_

- Added Well-Architected Framework benchmark (`steampipe check benchmark.well_architected_framework`). ([#22](https://github.com/turbot/steampipe-mod-aws-well-architected/pull/22))
- New dashboards added: ([#21](https://github.com/turbot/steampipe-mod-aws-well-architected/pull/21))
  - [AWS Well-Architected Workload Detail](https://hub.steampipe.io/mods/turbot/aws_well_architected/dashboards/dashboard.wellarchitected_workload_detail)
  - [AWS Well-Architected Workload Risks Report](https://hub.steampipe.io/mods/turbot/aws_well_architected/dashboards/dashboard.wellarchitected_workload_risks_report)

_Dependencies_

- AWS Compliance mod `v0.66` or higher is now required. ([#22](https://github.com/turbot/steampipe-mod-aws-well-architected/pull/22))

## v0.7 [2023-05-22]

_Dependencies_

- AWS Compliance mod `v0.64` or higher is now required.

_Bug fixes_

- Fixed semver constraint for AWS Compliance mod to require a minimum minor version instead of an exact minor version.
- Removed unused ECS queries that are now in AWS Compliance mod controls. ([#18](https://github.com/turbot/steampipe-mod-aws-well-architected/pull/18))

## v0.6 [2023-05-03]

_Bug fixes_

- Fixed dashboard localhost URLs in README and index doc. ([#15](https://github.com/turbot/steampipe-mod-aws-well-architected/pull/15))

## v0.5 [2023-04-24]

_Dependencies_

- AWS Compliance mod `v0.63` or higher is now required. ([#9](https://github.com/turbot/steampipe-mod-aws-well-architected/pull/9))

## v0.4 [2023-04-19]

_Bug fixes_

- Added variables and locals to this mod to avoid incorrect referenecs to those in the AWS Compliance mod. ([#11](https://github.com/turbot/steampipe-mod-aws-well-architected/pull/11))

## v0.3 [2023-04-19]

_Dependencies_

- AWS Compliance mod `v0.62` or higher is now required. ([#4](https://github.com/turbot/steampipe-mod-aws-well-architected/pull/4))

## v0.2 [2023-04-12]

_Bug fixes_

- Fixed reference to `apigateway_rest_api_stage_use_ssl_certificate` control in `security_9` benchmark to use fully qualified resource name.

## v0.1 [2023-04-10]

_What's new?_

- Added: Reliability Pillar benchmark (`steampipe check benchmark.reliability`)
- Added: Security Pillar benchmark (`steampipe check benchmark.security`)
