# AWS Well-Architected Mod for Powerpipe

200+ checks covering AWS Well-Architected Framework defined best practices across all AWS regions.

Run checks in a dashboard:
![image](https://raw.githubusercontent.com/turbot/steampipe-mod-aws-well-architected/main/docs/aws_well_architected_reliability_dashboard.png)

Or in a terminal:
![image](https://raw.githubusercontent.com/turbot/steampipe-mod-aws-well-architected/main/docs/aws_well_architected_console.png)

## Getting Started

### Installation

Install Powerpipe (https://powerpipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/powerpipe
```

This mod also requires [Steampipe](https://steampipe.io) with the [AWS plugin](https://hub.steampipe.io/plugins/turbot/aws) as the data source. Install Steampipe (https://steampipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/steampipe
steampipe plugin install aws
```

Steampipe will automatically use your default AWS credentials. Optionally, you can [setup multiple accounts](https://hub.steampipe.io/plugins/turbot/aws#multi-account-connections) or [customize AWS credentials](https://hub.steampipe.io/plugins/turbot/aws#configuring-aws-credentials).

Finally, install the mod:

```sh
mkdir dashboards
cd dashboards
powerpipe mod init
powerpipe mod install github.com/turbot/steampipe-mod-aws-well-architected
```

### Browsing Dashboards

Start Steampipe as the data source:

```sh
steampipe service start
```

Start the dashboard server:

```sh
powerpipe server
```

Browse and view your dashboards at **http://localhost:9033**.

### Running Checks in Your Terminal

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `powerpipe benchmark` command:

List available benchmarks:

```sh
powerpipe benchmark list
```

Run a benchmark:

```sh
powerpipe benchmark run well_architected_framework
```

Run a benchmark for a specific pillar:

```sh
powerpipe benchmark run well_architected_framework_security
```

Run a benchmark for a specific question:

```sh
powerpipe benchmark run well_architected_framework_sec01
```

Run a benchmark for a specific best practice:

```sh
powerpipe benchmark run well_architected_framework_sec01_bp01
```

Different output formats are also available, for more information please see
[Output Formats](https://powerpipe.io/docs/reference/cli/benchmark#output-formats).

### Common and Tag Dimensions

The benchmark queries use common properties (like `account_id`, `connection_name` and `region`) and tags that are defined in the dependent [AWS Compliance mod](https://github.com/turbot/steampipe-mod-aws-compliance) These properties can be executed in the following ways:

It's easiest to setup your vars file, starting with the sample:

```sh
cp steampipe.spvars.example steampipe.spvars
vi steampipe.spvars
```

Alternatively you can pass variables on the command line:

```sh
powerpipe benchmark run well_architected_framework_security --var 'common_dimensions=["account_id", "connection_name", "region"]'
```

Or through environment variables:

```sh
export PP_VAR_common_dimensions='["account_id", "connection_name", "region"]'
export PP_VAR_tag_dimensions='["Environment", "Owner"]'
powerpipe benchmark run well_architected_framework_security
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Steampipe](https://steampipe.io) and [Powerpipe](https://powerpipe.io) are products produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). They are distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #powerpipe on Slack →](https://turbot.com/community/join)**

Want to help but don't know where to start? Pick up one of the `help wanted` issues:

- [Powerpipe](https://github.com/turbot/powerpipe/labels/help%20wanted)
- [AWS Well-Architected Mod](https://github.com/turbot/steampipe-mod-aws-well-architected/labels/help%20wanted)

## Credits

- Thanks to [@JPPienaar](https://github.com/JPPienaar) and [@nathanwebsterdotme](https://github.com/nathanwebsterdotme) from [Daemon](https://github.com/Daemon-Solutions) for developing some of the control mappings used in the Well-Architected Framework benchmarks.
