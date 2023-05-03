## v0.6

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
